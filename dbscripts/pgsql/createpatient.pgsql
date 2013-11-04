	create table patient (
		patid		char(20),
		issuer		char(100),
		patid2		char(20),
		issuer2		char(100),
		nam		char(64),
		datbir		char(8),
		sex		char(4),
		pataccnum	char(20),
		patrac		char(20)
	);

	create index patid_index
	on patient(patid);

	create index nam_index
	on patient(nam);
