delete from reports;
delete from patient;

insert into patient
(patid, issuer, patid2, issuer2, nam, datbir, sex, addr,
pataccnum, patrac, xrefkey) values
('RID10111', 'RID', '', '', 'CRIS^CHARLIE', '19820102', 'M',
'7000 CORNELL^^ST. LOUIS^MO^63130',
'ACCT-10111', 'WH', 10111);

insert into reports
(patid, issuer, rpttype, rpttxt) values
('RID10111', 'RID', 'SUMMARY-RADIOLOGY',
'Radiology Report: Normal Chest XRay');

insert into reports
(patid, issuer, rpttype, rpttxt) values
('RID10111', 'RID', 'SUMMARY-CARDIOLOGY',
'Cardiology Report: Treadmill exam, normal results');

insert into patient
(patid, issuer, patid2, issuer2, nam, datbir, sex, addr,
pataccnum, patrac, xrefkey) values
('RID10112', 'RID', '', '', 'DANUBE^DARLENE', '19430102', 'F',
'4500 SCOTT^^ST. LOUIS^MO^63110',
'ACCT-10112', 'WH', 10112);


insert into reports
(patid, issuer, rpttype, rpttxt) values
('RID10112', 'RID', 'SUMMARY-CARDIOLOGY',
'Cardiology Report: Treadmill exam');

insert into reports
(patid, issuer, rpttype, rpttxt) values
('RID10112', 'RID', 'SUMMARY-RADIOLOGY',
'Radiology Report:<p>History: 60 year old female suffering long term ... </p><p>Findings: Chest X-Rays show lungs are clear</p>');

insert into patient
(patid, issuer, patid2, issuer2, nam, datbir, sex, addr,
pataccnum, patrac, xrefkey) values
('ECG203012', 'RID', '', '', 'SOMMER^ISAAC', '19900404', 'M',
'4444 DRIVE^^ST. LOUIS^MO^63130',
'ACCT-203012', 'WH', 203012);

insert into patient
(patid, issuer, patid2, issuer2, nam, datbir, sex, addr,
pataccnum, patrac, xrefkey) values
('ECG203011', 'RID', '', '', 'EHEL^JOSEPH', '19900202', 'M',
'3333 TEST^^AVE. LOUIS^MO^63130',
'ACCT-203011', 'WH', 203011);

insert into reports
(patid, issuer, rpttype, rpttxt) values
('ECG203011', 'RID', 'SUMMARY',
'Cardiology Report: Cardiology Report: Treadmill exam');

insert into reports
(patid, issuer, rpttype, rpttxt, rptxml,rptpath) values
('ECG203011', 'RID', 'SUMMARY-CARDIOLOGY-ECG', ' ',
'ecg/ecg20304.xml', 'MESA_STORAGE');


insert into reports
(patid, issuer, rpttype, rpttxt) values
('ECG203011', 'RID', 'SUMMARY-CARDIOLOGY',
'Cardiology Report: Cardiology Report:');

