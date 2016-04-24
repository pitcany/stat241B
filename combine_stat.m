function [historic_stat] = combine_stat(team,data,n,weights)
%for a given team, gives us aggregate totals for prior n games
%split by if team was at home or away

SetDefaultValue(1, 'team', 'Inter');
SetDefaultValue(2, 'data', 'train');
SetDefaultValue(3, 'n', 5);
SetDefaultValue(4, 'weights', ones(1,n));

is_team_playing = cellfun(@(x) strcmp(x,team),[data.AwayTeam data.HomeTeam]);
Team_At_Away = is_team_playing(:,1);
Team_At_Home = is_team_playing(:,2);
is_team_playing = Team_At_Away + Team_At_Home;

homewin = strcmp(data(:,'FTR').FTR,'H');
awaywin = strcmp(data(:,'FTR').FTR,'A') * -1;
result = homewin + awaywin;
result_by_team = result .* (Team_At_Home - Team_At_Away);

goals_TeamAtHome = data(:,'FTHG').FTHG .* Team_At_Home;
goals_TeamAtAway = data(:,'FTAG').FTAG .* Team_At_Away;
goals_by_team = goals_TeamAtHome + goals_TeamAtAway;

shots_TeamAtHome = data(:,'FTHG').FTHG .* Team_At_Home;
shots_TeamAtAway = data(:,'FTAG').FTAG .* Team_At_Away;
shots_by_team = shots_TeamAtHome + shots_TeamAtAway;

corners_TeamAtHome = data(:,'HC').HC .* Team_At_Home;
corners_TeamAtAway = data(:,'AC').AC .* Team_At_Away;
corners_by_team = corners_TeamAtHome + corners_TeamAtAway;

%initialize our historical data
num_matches = height(data);

form_Home = zeros(num_matches,1);
form_Away = zeros(num_matches,1);
agg_goals_Home = zeros(num_matches,1);
agg_goals_Away = zeros(num_matches,1);
agg_shots_Home = zeros(num_matches,1);
agg_shots_Away = zeros(num_matches,1);
agg_corners_Home = zeros(num_matches,1);
agg_corners_Away = zeros(num_matches,1);
features_Home = [form_Home agg_goals_Home agg_shots_Home agg_corners_Home];
features_Away = [form_Away agg_goals_Away agg_shots_Away agg_corners_Away];
is_lookback_game_in_season = zeros(num_matches,1);

rows_for_team=find(is_team_playing);
for i=(n+1):length(rows_for_team)
    rows_to_combine = rows_for_team((i-n):(i-1));
    cur_row=rows_for_team(i);
    %check if we are still looking back in the same season
    %cur_row and lookback_row are row indices
    lookback_row = rows_for_team(i-n);
    if (data(cur_row,'Season').Season == data(lookback_row,'Season').Season)
        is_lookback_game_in_season(cur_row) = 1;
    
        if (ismember(data(cur_row,'HomeTeam').HomeTeam,team) == 1)
             features_Home(cur_row,:)=weights*[result_by_team(rows_to_combine)... 
             goals_by_team(rows_to_combine)...
             shots_by_team(rows_to_combine)... 
             corners_by_team(rows_to_combine)];
        else
             features_Away(cur_row,:)=weights*[result_by_team(rows_to_combine)... 
             goals_by_team(rows_to_combine)...
             shots_by_team(rows_to_combine)... 
             corners_by_team(rows_to_combine)];
        end
        
    end
    
end

A=num2cell(features_Home,1);
B=num2cell(features_Away,1);

[form_Home, agg_goals_Home, agg_shots_Home, agg_corners_Home]=deal(A{:});
[form_Away, agg_goals_Away, agg_shots_Away, agg_corners_Away]=deal(B{:});

historic_stat = [form_Home form_Away agg_goals_Home agg_goals_Away agg_shots_Home agg_shots_Away agg_corners_Home agg_corners_Away is_lookback_game_in_season];

%now calculate the total goals scored, goals against, shots, corners, fouls
%for the home team

