delete from doc_reference;

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), 'RID10111', 'JPEG', '/tmp', 'bob.jpeg');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), 'RID10112', 'PDF', '/tmp', 'bob.pdf');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), 'RID10113', 'JPEG', '', '/tmp/bob.jpeg');


insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2003.100.101', 'JPEG', 'MESA_STORAGE', 'rid/10141.jpeg'); 
insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2003.100.102', 'PDF', 'MESA_STORAGE', 'rid/10142.pdf');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2003.100.104', 'JPEG', 'MESA_STORAGE', 'rid/10144.jpeg');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2003.100.104', 'PDF', 'MESA_STORAGE', 'rid/10144.pdf');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2005.20301.101', 'PDF', 'MESA_STORAGE', 'ecg/20301.pdf');

insert into doc_reference
(oid_seq, document_oid, doc_type, path_root, path)
values
(nextval('oid_seq_num'), '1.2.840.113654.2.3.2005.20301.102', 'SVG', 'MESA_STORAGE', 'ecg/20301.svg');
