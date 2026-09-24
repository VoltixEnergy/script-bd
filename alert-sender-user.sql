create user alert_sender_user identified by 'senha_aqui';
grant insert, select on voltix.* to alert_sender_user;
flush privileges;