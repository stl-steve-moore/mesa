create table patient (
	patient_key	serial PRIMARY KEY,
	patid		varchar(20),
	issuer		varchar(128),
	patid2		varchar(20),
	issuer2		varchar(128),
	nam			varchar(64),
	nam_iso		varchar(256),
	nam_euc		varchar(256),
	datbir		varchar(8),
	sex			varchar(4),
	addr		varchar(106),
	pataccnum	varchar(20),
	patrac		varchar(20),
	xrefkey		char(20),
	UNIQUE (patid, issuer)
);

create index patid_index
on patient(patid);

create index nam_index
on patient(nam);
