	create table last_req (
		ini		char(4),
		lasreqdat	int,
		lasreqtyp	char(10)
	);

	create unique index ini_last_req
	on last_req(ini);
	
