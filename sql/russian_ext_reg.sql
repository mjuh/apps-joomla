INSERT INTO `${TABLE_PREFIX}_extensions` (`package_id`, `name`, `type`, `element`, `folder`, `client_id`, `enabled`, `access`, `protected`, `locked`, `manifest_cache`, `params`, `custom_data`)  VALUES
(0,'Russian (ru-RU)','language','ru-RU','',0,1,1,0,0,'','{}',''),
(0,'Russian (ru-RU)','language','ru-RU','',1,1,1,0,0,'','{}',''),
(0,'Russian (ru-RU)','language','ru-RU','',3,1,1,0,0,'','{}','');
INSERT INTO `${TABLE_PREFIX}_assets` (`parent_id`, `lft`, `rgt`, `level`, `name`, `title`, `rules`) VALUES
(11,0,0,2,'com_languages.language.2','Russian (ru-RU)','{}');
UPDATE `${TABLE_PREFIX}_languages` SET ordering = 2 WHERE lang_code = 'en_gb';
INSERT INTO `${TABLE_PREFIX}_languages` (`lang_id`, `lang_code`, `title`, `title_native`, `sef`, `image`, `description`, `metakey`, `metadesc`, `sitename`, `published`, `access`, `ordering`) VALUES
(91,'ru-RU','Russian (ru-RU)','Русский (Россия)','ru','ru_ru','','','','',0,1,1);
UPDATE `${TABLE_PREFIX}_extensions` SET params = REPLACE(params, 'en-GB', 'ru-RU') WHERE name = 'com_languages';