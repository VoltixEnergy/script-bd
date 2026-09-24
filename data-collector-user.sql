create user data_collector_user identified by 'senha_aqui';
grant select on voltix.* to data_collector_user;
flush privileges;