	create table series (
		stuinsuid	char(64),
		serinsuid	char(64),
		mod		char(16),
		sernum		char(20),
		pronam		char(64),
		serdes		char(64),
		serdat		char(12),
		ppsstadat	char(12),
		ppsstatim	char(16),
		lastmod		char(32),
		numins		int
	);

	create index serinsuid_series
	on series(serinsuid);
