create table patient (
	patient_key	int identity,
	patid		varchar(20),
	issuer		varchar(100),
	identifier_type	varchar(100),
	patid2		varchar(20) null,
	issuer2		varchar(100) null,
	nam		char(64) null,
	datbir		char(8) null,
	sex		char(4) null,
	addr		char(106) null,
	pataccnum	char(20) null,
	patrac		char(20) null,
	xrefkey		char(32) null,
	UNIQUE (patid, issuer)
)

create index patid_index
on patient(patid)

create index nam_index
on patient(nam)

go

create table visit (
	visnum		char(60),
	patid		varchar(20),
	issuer		varchar(100),
	patcla		char(20),
	asspatloc	char(64) null,
	attdoc		char(64) null,
	admdat		char(8) null,
	admtim		char(8) null,
	presta		char(20) null,
	refdoc		char(64) null,
	admdoc		char(64) null
)

create index visnum_index
on visit(visnum)

go

create table issuer (
	issuer_key	int identity,
	issuer		varchar(100),
	UNIQUE(issuer)
)
go
