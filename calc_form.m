function [historic_stat] = calc_form(team,data,n)
%for a given team, gives us aggregate totals for prior n games
%split by if team was at home or away

is_team_playing = cellfun(@(x) strcmp(x,team),[data.AwayTeam data.HomeTeam]);
matchresult = is_team_playing(:,1)+is_team_playing(:,2);
Team_At_Away = is_team_playing(:,1);
Team_At_Home = is_team_playing(:,2);

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

%initialize our historical data
num_matches = height(data);

form_Home = zeros([num_matches,1]);
form_Away = zeros([num_matches,1]);
total_goals_Home = zeros([num_matches,1]);
total_goals_Away = zeros([num_matches,1]);
total_shots_Home = zeros([num_matches,1]);
total_shots_Away = zeros([num_matches,1]);

rows_for_team=find(matchresult);
for i=(n+1):length(rows_for_team)
    rows_to_combine = rows_for_team((i-n):(i-1));
    cur_row=rows_for_team(i);
    if (ismember(data(cur_row,'HomeTeam').HomeTeam,team) == 1)
        form_Home(cur_row)=sum(result_by_team(rows_to_combine));
        total_goals_Home(cur_row)=sum(goals_by_team(rows_to_combine));
        total_shots_Home(cur_row)=sum(shots_by_team(rows_to_combine));
    else
        form_Away(cur_row)=sum(result_by_team(rows_to_combine));
        total_goals_Away(cur_row)=sum(goals_by_team(rows_to_combine));
        total_shots_Away(cur_row)=sum(shots_by_team(rows_to_combine));
    end
end

historic_stat = [form_Home form_Away total_goals_Home total_goals_Away total_shots_Home total_shots_Away];

%now calculate the total goals scored, goals against, shots, corners, fouls
%for the home team

