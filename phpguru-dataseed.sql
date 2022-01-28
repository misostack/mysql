USE `phpguru-portal`;

INSERT INTO `phpguru_users`
(
`login`,`password`,`email`,`first_name`,`last_name`,
`type`,`status`,`created_at`,`updated_at`,`is_super_admin`,`gender`)
VALUES
(
'theuser9999','123456','theuser9999@yopmail.com','theuser9999','lee',
'member','active','2021-10-28 15:00:00','2021-10-28 15:00:00',0,'M'
);

INSERT INTO `phpguru_sessions`
(
`user_id`,`login_at`,`logout_at`,`user_agent`)
VALUES
(
	1,'2021-10-28 15:00:00','2021-10-28 18:00:00','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36'
);