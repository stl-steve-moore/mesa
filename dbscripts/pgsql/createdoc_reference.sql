create sequence oid_seq_num;

create table doc_reference (
	patient_key	serial PRIMARY KEY,
	oid_seq		int,
	document_oid	char(64),
	doc_type	char(4),
	path		char(20),
	path_root	char(64),
	xrefkey		int
);

