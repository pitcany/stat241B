function [test_feature_table] = features_test(test,varargin)
%feature selection for training data. test data will be similar except
%replace train with test everywhere

p=inputParser;
addRequired(p,'train',@istable);
addOptional(p,'n',5,@isnumeric);
addOptional(p,'weights',[],@isnumeric);

parse(p,test,varargin{:});
n = p.Results.n;

if (isempty(p.Results.weights))
    weights = ones(1,n);
else
    weights = p.Results.weights;
end

teams={'Ascoli','Atalanta','Bari','Bologna','Brescia','Cagliari','Catania','Cesena','Chievo','Empoli','Fiorentina','Genoa','Inter','Juventus','Lazio','Lecce','Livorno','Messina','Milan','Napoli','Novara','Palermo','Parma','Pescara','Reggina','Roma','Sampdoria','Sassuolo','Siena','Torino','Udinese','Verona'};
%weights = ones(1,7);
%weights1=exp([1 2 3 4 5 6 7])/sum(exp([1 2 3 4 5 6 7]));
all_teams_historical_test=arrayfun(@(x) combine_stat(x,test,n,weights), teams, 'UniformOutput', false);

catTeams = cat(3,all_teams_historical_test{:});
historical_data_test=sum(catTeams,3);

clear test_feature_table;
test_feature_table = table;
test_feature_table.Date = test(:,'Date').Date;
test_feature_table.HomeTeam = test(:,'HomeTeam').HomeTeam;
test_feature_table.AwayTeam = test(:,'AwayTeam').AwayTeam;
test_feature_table.FTR = test(:,'FTR').FTR;
test_feature_table.form_Home = historical_data_test(:,1);
test_feature_table.form_Away = historical_data_test(:,2);
test_feature_table.agg_goals_Home = historical_data_test(:,3);
test_feature_table.agg_goals_Away = historical_data_test(:,4);
test_feature_table.agg_shots_Home = historical_data_test(:,5);
test_feature_table.agg_shots_Away = historical_data_test(:,6);
test_feature_table.agg_corners_Home = historical_data_test(:,7);
test_feature_table.agg_corners_Away = historical_data_test(:,8);
test_feature_table.agg_form_differential = historical_data_test(:,1)-historical_data_test(:,2);
test_feature_table.agg_goal_differential = historical_data_test(:,3)-historical_data_test(:,4);
test_feature_table.agg_shot_differential = historical_data_test(:,5)-historical_data_test(:,6);
test_feature_table.agg_corners_differential = historical_data_test(:,7)-historical_data_test(:,8);
test_feature_table.B365H = test(:,'B365H').B365H;
test_feature_table.B365D = test(:,'B365D').B365D;
test_feature_table.B365A = test(:,'B365A').B365A;
test_feature_table.HomeWins = strcmp(test(:,'FTR').FTR,'H');
test_feature_table.lookback = historical_data_test(:,9);

%filter rows that don't have enough prior historical data aka lookback is 2
%home and away teams have a lookback value of 1 so the sum is 2. that's
%why.

rows_needed=test_feature_table(:,'lookback').lookback == 2;
test_feature_table = test_feature_table(rows_needed,1:(end-1));

clear all_teams_historical_test catTeams historical_data_test rows_needed teams;