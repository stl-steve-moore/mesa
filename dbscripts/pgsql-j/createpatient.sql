create table patient (
	patient_key	serial PRIMARY KEY,
	patid		varchar(20),
	issuer		varchar(20),
	patid2		varchar(20),
	issuer2		varchar(20),
	nam		varchar(192),
	datbir		varchar(8),
	sex		varchar(4),
	addr		varchar(250),
	pataccnum	varchar(20),
	patrac		varchar(20),
	xrefkey		char(20),
	UNIQUE (patid, issuer)
);

create index patid_index
on patient(patid);

create index nam_index
on patient(nam);
