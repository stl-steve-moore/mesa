	create table patient (
		patid		char(20),
		issuer		char(100),
		identifier_type char(100),
		patid2		char(20),
		issuer2		char(100),
		nam		char(64),
		datbir		char(8),
		sex		char(4),
		addr		char(106),
		pataccnum	char(20) NULL,
		patrac		char(20) NULL,
		xrefkey		char(20) NULL
	);

	create index patid_index
	on patient(patid)
	go

	create index nam_index
	on patient(nam)
	go

quit

