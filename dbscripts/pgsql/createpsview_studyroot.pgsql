	create table ps_view (
		patid		char(20),
		issuer		char(100),
		patid2		char(20),
		issuer2		char(100),
		nam		char(64),
		datbir		char(8),
		sex		char(4),
		pataccnum	char(20),
		patrac		char(20),
		stuinsuid	char(64),
		constuuid	char(64),
		stuid		char(64),
		stuorg		char(16),
		studat		char(16),
		stutim		char(16),
		accnum		char(16),
		refphynam	char(64),
		studes		char(64),
		patage		char(16),
		patsiz		char(16),
		patsex		char(16),
		modinstu	char(32),
		lastmod		char(32),
		numser		int,
		numins		int
	);

	create index stuinsuid_series
	on ps_view(stuinsuid);

	create index patid_index
	on ps_view(patid);

	create index nam_index
	on ps_view(nam);

