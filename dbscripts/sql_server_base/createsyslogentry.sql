	create table syslogentry (
		facility	int,
		severity	int,
		timestamp	char(10),
		datestamp	char(10),
		datetime	char(20),
		host		char(64),
		identifier	int IDENTITY,
		message		varchar(4096)
	)
	go


quit

