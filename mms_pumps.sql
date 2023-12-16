CREATE TABLE `mms_pumps` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`pumpid` TEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`model` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`storage` INT(11) NULL DEFAULT '0',
	`weight` INT(11) NULL DEFAULT '0',
	`active` INT(11) NULL DEFAULT '0',
	`temppump` INT(11) NULL DEFAULT '0',
	`pumpposx` FLOAT NULL DEFAULT '0',
	`pumpposy` FLOAT NULL DEFAULT '0',
	`pumpposz` FLOAT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=68
;
