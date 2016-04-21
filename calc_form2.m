teams={'Ascoli','Atalanta','Bari','Bologna','Brescia','Cagliari','Catania','Cesena','Chievo','Empoli','Fiorentina','Genoa','Inter','Juventus','Lazio','Lecce','Livorno','Messina','Milan','Napoli','Novara','Palermo','Parma','Pescara','Reggina','Roma','Sampdoria','Sassuolo','Siena','Torino','Udinese','Verona'};
all_teams_historical=arrayfun(@(x) calc_form(x,train,3), teams, 'UniformOutput', false);
catTeams = cat(3,all_teams_historical{:});
historical_data=sum(catTeams,3);