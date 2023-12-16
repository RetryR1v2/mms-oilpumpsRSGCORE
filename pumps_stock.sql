CREATE TABLE `pumps_stock` (
	`stash` TEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`item` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`oil` INT(11) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
