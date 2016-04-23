%feature selection for training data. test data will be similar except
%replace train with test everywhere

teams={'Ascoli','Atalanta','Bari','Bologna','Brescia','Cagliari','Catania','Cesena','Chievo','Empoli','Fiorentina','Genoa','Inter','Juventus','Lazio','Lecce','Livorno','Messina','Milan','Napoli','Novara','Palermo','Parma','Pescara','Reggina','Roma','Sampdoria','Sassuolo','Siena','Torino','Udinese','Verona'};
all_teams_historical_train=arrayfun(@(x) combine_stat(x,train,7), teams, 'UniformOutput', false);
catTeams = cat(3,all_teams_historical_train{:});
historical_data_train=sum(catTeams,3);

train_feature_table = table;
train_feature_table.Date = train(:,'Date').Date;
train_feature_table.HomeTeam = train(:,'HomeTeam').HomeTeam;
train_feature_table.AwayTeam = train(:,'AwayTeam').AwayTeam;
train_feature_table.FTR = train(:,'FTR').FTR;
train_feature_table.form_Home = historical_data_train(:,1);
train_feature_table.form_Away = historical_data_train(:,2);
train_feature_table.total_goals_Home = historical_data_train(:,3);
train_feature_table.total_goals_Away = historical_data_train(:,4);
train_feature_table.total_shots_Home = historical_data_train(:,5);
train_feature_table.total_shots_Away = historical_data_train(:,6);
train_feature_table.total_corners_Home = historical_data_train(:,7);
train_feature_table.total_corners_Away = historical_data_train(:,8);
train_feature_table.total_form_differential = historical_data_train(:,1)-historical_data_train(:,2);
train_feature_table.total_goal_differential = historical_data_train(:,3)-historical_data_train(:,4);
train_feature_table.total_shot_differential = historical_data_train(:,5)-historical_data_train(:,6);
train_feature_table.total_corners_differential = historical_data_train(:,7)-historical_data_train(:,8);
train_feature_table.B365H = train(:,'B365H').B365H;
train_feature_table.B365D = train(:,'B365D').B365D;
train_feature_table.B365A = train(:,'B365A').B365A;
train_feature_table.HomeWins = strcmp(train(:,'FTR').FTR,'H');
train_feature_table.lookback = historical_data_train(:,9);

%filter rows that don't have enough prior historical data aka lookback is 2
%home and away teams have a lookback value of 1 so the sum is 2. that's
%why.

rows_needed=train_feature_table(:,'lookback').lookback == 2;
train_feature_table = train_feature_table(rows_needed,1:(end-1));

clear all_teams_historical_train catTeams historical_data_train rows_needed teams;