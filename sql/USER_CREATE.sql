INSERT INTO `${TABLE_PREFIX}_user_usergroup_map` (`user_id`, `group_id`) VALUES (360,8);
INSERT INTO `${TABLE_PREFIX}_users` (`id`, `name`, `username`, `email`, `password`, `usertype`, `block`, `sendEmail`, `registerDate`, `lastvisitDate`, `activation`, `params`) VALUES
(360,'${ADMIN_USERNAME}','${ADMIN_USERNAME}','${ADMIN_EMAIL}','${ADMIN_PASSWORD_HASH}','',0,1,'${INSTALL_DATETIME}','${INSTALL_DATETIME}','','');
