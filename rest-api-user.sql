create user rest_api_user identified by 'senha_aqui';
grant insert, select, update on voltix.* to rest_api_user;
flush privileges;