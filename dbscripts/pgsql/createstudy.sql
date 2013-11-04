	create table study (
		patid		varchar(20),
		stuinsuid	varchar(64),
		constuuid	varchar(64),
		stuid		varchar(64),
		stuorg		varchar(16),
		studat		varchar(16),
		stutim		varchar(16),
		accnum		varchar(16),
		refphynam	varchar(64),
		studes		varchar(64),
		patage		varchar(16),
		patsiz		varchar(16),
		patsex		varchar(16),
		modinstu	varchar(32),
		lastmod		varchar(32),
		numser		int,
		numins		int
	);

	create index stuinsuid_series
	on study(stuinsuid);
