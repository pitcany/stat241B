function [total_goals] = calc_form(team,data,n)
%for a given team, gives us aggregate totals for prior n games
%split by if team was at home or away

is_team_playing = cellfun(@(x) strcmp(x,team),[data.AwayTeam data.HomeTeam]);
matchresult = is_team_playing(:,1)+is_team_playing(:,2);
Team_At_Away = is_team_playing(:,1);
Team_At_Home = is_team_playing(:,2);

goals_TeamAtHome = data(:,'FTHG').FTHG .* Team_At_Home;
goals_TeamAtAway = data(:,'FTAG').FTAG .* Team_At_Away;
goals_by_team = goals_TeamAtHome + goals_TeamAtAway;

num_matches = height(data);
total_goals_Home = zeros([num_matches,1]);
total_goals_Away = zeros([num_matches,1]);

rows_for_team=find(matchresult);
for i=(n+1):length(rows_for_team)
    rows_to_combine = rows_for_team((i-n):(i-1));
    cur_row=rows_for_team(i);
    if (ismember(data(cur_row,'HomeTeam').HomeTeam,team) == 1)
        total_goals_Home(cur_row)=sum(goals_by_team(rows_to_combine));
    else
        total_goals_Away(cur_row)=sum(goals_by_team(rows_to_combine));
    end
end

total_goals = [total_goals_Home total_goals_Away];

%now calculate the total goals scored, goals against, shots, corners, fouls
%for the home team

