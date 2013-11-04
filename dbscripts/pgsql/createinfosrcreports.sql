create table reports (
	report_key	serial PRIMARY KEY,
	patient_key	int,
	patid		varchar(20),
	issuer		varchar(100),
	rpttype		char(32),
	rpttxt		text,
	rptdatetime	timestamp default 'now',
	rptxml		char(20) null,
	rptpath		char(256) null,

	constraint report_patient_constraint foreign key (patid, issuer) references patient(patid, issuer)
);

