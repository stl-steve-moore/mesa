/*drop view reportview;
drop table patient;
drop table visit;
drop table reports;
drop table doc_reference;
*/

create table patient (
	patient_key	int identity,
	patid		varchar(20),
	issuer		varchar(100),
	patid2		varchar(20),
	issuer2		varchar(100),
	nam		char(64),
	datbir		char(8),
	sex		char(4),
	addr		char(106),
	pataccnum	char(20),
	patrac		char(20),
	xrefkey		int null,
	UNIQUE (patid, issuer)
)

create index patid_index
on patient(patid)

create table visit (
	visnum		char(20),
	patid		varchar(20),
	issuer		varchar(100),
	patcla		char(20),
	asspatloc	char(64),
	attdoc		char(64),
	admdat		char(8),
	admtim		char(8),
	presta		char(20),
	refdoc		char(64)
)

create index visnum_index
on visit(visnum)

go

create table reports (
	report_key	int identity,
	patient_key	int null,
	patid		char(20),
	issuer		char(100),
	rpttype		char(32),
	rpttxt		text,
	rptdatetime	datetime default GETDATE(),
      rptxml 	char(20) null,
      rptpath	char(256) null
)

go


create table doc_reference (
	patient_key	int null,
	oid_seq		int identity,
	document_oid	char(64),
	doc_type	char(4),
	path		char(20),
	path_root	char(64),
	xrefkey		int null
)

go

create view reportview as
  select patient.patid, patient.issuer, patient.nam, patient.datbir,
	 patient.sex,   patient.patrac,
	 reports.rpttype, reports.rpttxt, reports.rptdatetime,
       reports.rptxml, reports.rptpath
  from patient, reports
  where patient.patid = reports.patid and
	patient.issuer = reports.issuer
go

quit

