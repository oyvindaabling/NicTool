
DROP TABLE IF EXISTS nt_zone_nameserver;
CREATE TABLE nt_zone_nameserver (
    nt_zone_id           smallint(5) unsigned NOT NULL,
    nt_nameserver_id     smallint(5) unsigned NOT NULL
) DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS resource_record_type;
CREATE TABLE resource_record_type (
    id              smallint(2) unsigned NOT NULL AUTO_INCREMENT,
    name            varchar(10) NOT NULL,
PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

INSERT INTO resource_record_type VALUES (2,'NS'),(5,'CNAME'),(6,'SOA'),(12,'PTR'),(15,'MX'),(28,'AAAA'),(33,'SRV'),(99,'SPF'),(252,'AXFR'),(1,'A'),(16,'TXT'),(48,'DNSKEY'),(43,'DS'),(25,'KEY');

/* nt_zone */
ALTER TABLE nt_zone ADD column `location` VARCHAR(2) DEFAULT NULL  AFTER `ttl`;
ALTER TABLE nt_zone ADD column `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP AFTER `location`;

/* TODO: import NS settings from existing nt_zone table, and then:
ALTER TABLE nt_zone DROP column ns0;
ALTER TABLE nt_zone DROP column ns1;
ALTER TABLE nt_zone DROP column ns2;
ALTER TABLE nt_zone DROP column ns3;
ALTER TABLE nt_zone DROP column ns4;
ALTER TABLE nt_zone DROP column ns5;
ALTER TABLE nt_zone DROP column ns6;
ALTER TABLE nt_zone DROP column ns7;
ALTER TABLE nt_zone DROP column ns8;
ALTER TABLE nt_zone DROP column ns9;
*/

/* nt_zone_record */
ALTER TABLE nt_zone_record ADD `location` VARCHAR(2) DEFAULT NULL  AFTER `other`;
ALTER TABLE nt_zone_record ADD `timestamp` timestamp NULL DEFAULT NULL AFTER `location`;

/* nt_nameserver */
ALTER TABLE nt_nameserver DROP column `service_type`;
ALTER TABLE nt_nameserver ADD `export_serials` tinyint(1) UNSIGNED NOT NULL DEFAULT '1'  AFTER `export_interval`;
UPDATE nt_nameserver SET output_format='tinydns' WHERE output_format='nt';
ALTER TABLE nt_nameserver CHANGE `output_format` `export_format` enum('tinydns','bind') NOT NULL;

/* nt_nameserver_log */
ALTER TABLE nt_nameserver_log DROP column `service_type`;
ALTER TABLE nt_nameserver_log ADD `export_serials` tinyint(1) UNSIGNED NOT NULL DEFAULT '1'  AFTER `export_interval`;
UPDATE nt_nameserver_log SET output_format='tinydns' WHERE output_format='nt';
ALTER TABLE nt_nameserver_log CHANGE `output_format` `export_format` enum('tinydns','bind') NOT NULL;

/* nt_nameserver_export_log */
ALTER TABLE nt_nameserver_export_log ADD `result_id` int NULL DEFAULT NULL  AFTER `date_finish`;
ALTER TABLE nt_nameserver_export_log ADD `message` varchar(256) NULL DEFAULT NULL  AFTER `result_id`;
ALTER TABLE nt_nameserver_export_log ADD `success` tinyint(1) UNSIGNED NULL DEFAULT NULL  AFTER `message`;
ALTER TABLE nt_nameserver_export_log ADD `partial` tinyint(1) UNSIGNED NOT NULL DEFAULT 0  AFTER `success`;
ALTER TABLE nt_nameserver_export_log CHANGE `date_start` `date_start` timestamp NULL DEFAULT NULL;
ALTER TABLE nt_nameserver_export_log CHANGE `date_finish` `date_end` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP;

/* GLOBALLY change table.deleted columns from enum to tinyint(1) */
ALTER TABLE `nt_zone_record` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
/* and then decrement the values, because enums are evil */
UPDATE nt_zone_record SET deleted=deleted-1;
ALTER TABLE `nt_zone` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_zone SET deleted=deleted-1;
ALTER TABLE `nt_user` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_user SET deleted=deleted-1;
ALTER TABLE `nt_perm` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_perm SET deleted=deleted-1;
ALTER TABLE `nt_nameserver` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_nameserver SET deleted=deleted-1;
ALTER TABLE `nt_nameserver` CHANGE `export_serials` `export_serials` tinyint(1) UNSIGNED NOT NULL DEFAULT '1';
ALTER TABLE `nt_group` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_group SET deleted=deleted-1;
ALTER TABLE `nt_delegate` CHANGE `deleted` `deleted` tinyint(1) UNSIGNED NOT NULL DEFAULT 0;
UPDATE nt_delegate SET deleted=deleted-1;

/* Convert all character encodings to UTF8 bin. */
ALTER TABLE `nt_delegate` CHARACTER SET = utf8;
ALTER TABLE `nt_delegate` COLLATE = utf8_bin;

ALTER TABLE `nt_delegate_log` CHARACTER SET = utf8;
ALTER TABLE `nt_delegate_log` COLLATE = utf8_bin;

ALTER TABLE `nt_group` CHARACTER SET = utf8;
ALTER TABLE `nt_group` COLLATE = utf8_bin;

ALTER TABLE `nt_group_log` CHARACTER SET = utf8;
ALTER TABLE `nt_group_log` COLLATE = utf8_bin;

ALTER TABLE `nt_group_subgroups` CHARACTER SET = utf8;
ALTER TABLE `nt_group_subgroups` COLLATE = utf8_bin;

ALTER TABLE `nt_nameserver` CHARACTER SET = utf8;
ALTER TABLE `nt_nameserver` COLLATE = utf8_bin;

ALTER TABLE `nt_nameserver_log` CHARACTER SET = utf8;
ALTER TABLE `nt_nameserver_log` COLLATE = utf8_bin;

ALTER TABLE `nt_nameserver_export_log` CHARACTER SET = utf8;
ALTER TABLE `nt_nameserver_export_log` COLLATE = utf8_bin;

ALTER TABLE `nt_nameserver_qlog` CHARACTER SET = utf8;
ALTER TABLE `nt_nameserver_qlog` COLLATE = utf8_bin;

ALTER TABLE `nt_nameserver_qlogfile` CHARACTER SET = utf8;
ALTER TABLE `nt_nameserver_qlogfile` COLLATE = utf8_bin;

ALTER TABLE `nt_options` CHARACTER SET = utf8;
ALTER TABLE `nt_options` COLLATE = utf8_bin;

ALTER TABLE `nt_perm` CHARACTER SET = utf8;
ALTER TABLE `nt_perm` COLLATE = utf8_bin;

ALTER TABLE `nt_user` CHARACTER SET = utf8;
ALTER TABLE `nt_user` COLLATE = utf8_bin;

ALTER TABLE `nt_user_log` CHARACTER SET = utf8;
ALTER TABLE `nt_user_log` COLLATE = utf8_bin;

ALTER TABLE `nt_user_global_log` CHARACTER SET = utf8;
ALTER TABLE `nt_user_global_log` COLLATE = utf8_bin;

ALTER TABLE `nt_user_session` CHARACTER SET = utf8;
ALTER TABLE `nt_user_session` COLLATE = utf8_bin;

ALTER TABLE `nt_user_session_log` CHARACTER SET = utf8;
ALTER TABLE `nt_user_session_log` COLLATE = utf8_bin;

ALTER TABLE `nt_zone` CHARACTER SET = utf8;
ALTER TABLE `nt_zone` COLLATE = utf8_bin;

ALTER TABLE `nt_zone_log` CHARACTER SET = utf8;
ALTER TABLE `nt_zone_log` COLLATE = utf8_bin;

ALTER TABLE `nt_zone_record` CHARACTER SET = utf8;
ALTER TABLE `nt_zone_record` COLLATE = utf8_bin;

ALTER TABLE `nt_zone_record_log` CHARACTER SET = utf8;
ALTER TABLE `nt_zone_record_log` COLLATE = utf8_bin;

UPDATE nt_options SET option_value='2.10' WHERE option_name='db_version';

/* Converting to InnoDB brings us foreign key constraints. It is the
default database format in mysql 5.5. The only reason I can think of
for not doing this now is that InnoDB performance is 1/3 to 1/4 the
speed of MyISAM on mysql 5.1. InnoDB performance in 5.5 is improving.
mps - Nov 09, 2011

ALTER TABLE `nt_delegate` TYPE = InnoDB;
ALTER TABLE `nt_delegate_log` TYPE = InnoDB;
ALTER TABLE `nt_group` TYPE = InnoDB;
ALTER TABLE `nt_group_log` TYPE = InnoDB;
ALTER TABLE `nt_group_subgroups` TYPE = InnoDB;
ALTER TABLE `nt_nameserver` TYPE = InnoDB;
ALTER TABLE `nt_nameserver_log` TYPE = InnoDB;
ALTER TABLE `nt_nameserver_export_log` TYPE = InnoDB;
ALTER TABLE `nt_nameserver_qlog` TYPE = InnoDB;
ALTER TABLE `nt_nameserver_qlogfile` TYPE = InnoDB;
ALTER TABLE `nt_options` TYPE = InnoDB;
ALTER TABLE `nt_perm` TYPE = InnoDB;
ALTER TABLE `nt_user` TYPE = InnoDB;
ALTER TABLE `nt_user_log` TYPE = InnoDB;
ALTER TABLE `nt_user_global_log` TYPE = InnoDB;
ALTER TABLE `nt_user_session` TYPE = InnoDB;
ALTER TABLE `nt_user_session_log` TYPE = InnoDB;
ALTER TABLE `nt_zone` TYPE = InnoDB;
ALTER TABLE `nt_zone_log` TYPE = InnoDB;
ALTER TABLE `nt_zone_record` TYPE = InnoDB;
ALTER TABLE `nt_zone_record_log` TYPE = InnoDB;

When the time to switch to InnoDB comes, these constraints may prove beneficial

ALTER TABLE `nt_nameserver_export_log` ADD FOREIGN KEY (`result_id`) REFERENCES `nt_nameserver_export_result` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `nt_zone_log` ADD FOREIGN KEY (`nt_zone_id`) REFERENCES `nt_zone` (`nt_zone_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_log` ADD FOREIGN KEY (`nt_group_id`) REFERENCES `nt_group` (`nt_group_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_log` ADD FOREIGN KEY (`nt_user_id`) REFERENCES `nt_user` (`nt_user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_record` ADD FOREIGN KEY (`nt_zone_id`) REFERENCES `nt_zone` (`nt_zone_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_record_log` ADD FOREIGN KEY (`nt_zone_id`) REFERENCES `nt_zone` (`nt_zone_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_record_log` ADD FOREIGN KEY (`nt_user_id`) REFERENCES `nt_user` (`nt_user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_zone_record_log` ADD FOREIGN KEY (`nt_zone_record_id`) REFERENCES `nt_zone_record` (`nt_zone_record_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `nt_user_session_log` ADD FOREIGN KEY (`nt_user_id`) REFERENCES `nt_user` (`nt_user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_user_session_log` ADD FOREIGN KEY (`nt_user_session_id`) REFERENCES `nt_user_session` (`nt_user_session_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_user_session` ADD FOREIGN KEY (`nt_user_id`) REFERENCES `nt_user` (`nt_user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_user_global_log` ADD FOREIGN KEY (`nt_user_id`) REFERENCES `nt_user` (`nt_user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `nt_nameserver_export_log` ADD FOREIGN KEY (`result_id`) REFERENCES `nt_nameserver_export_result` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `nt_nameserver` ADD FOREIGN KEY (`nt_group_id`) REFERENCES `nt_group` (`nt_group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `nt_group_subgroups` ADD FOREIGN KEY (`nt_group_id`) REFERENCES `nt_group` (`nt_group_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `nt_group_log` ADD FOREIGN KEY (`nt_group_id`) REFERENCES `nt_group` (`nt_group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `nt_delegate` ADD FOREIGN KEY (`nt_group_id`) REFERENCES `nt_group` (`nt_group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

*/
