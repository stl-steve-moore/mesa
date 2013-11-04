	create table study (
		patid		char(20),
		stuinsuid	char(64),
		constuuid	char(64),
		stuid		char(64),
		stuorg		char(16) NULL,
		studat		char(16),
		stutim		char(16),
		accnum		char(16),
		refphynam	char(64),
		studes		char(64),
		patage		char(16),
		patsiz		char(16),
		patsex		char(16) NULL,
		modinstu	char(32),
		lastmod		char(32) NULL,
		numser		int,
		numins		int
	)
	go

	create index stuinsuid_series
	on study(stuinsuid);
	go
