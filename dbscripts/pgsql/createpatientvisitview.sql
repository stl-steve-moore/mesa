create view patient_visit AS SELECT
    patient.patient_key,
    patient.patid,
    patient.issuer,
    patient.nam, 
    patient.datbir, 
    patient.sex, 
    patient.addr, 
    patient.pataccnum, 
    patient.patrac,
    visit.visnum,
    visit.viskey,
    visit.patcla,
    visit.asspatloc,
    visit.attdoc,
    visit.admdoc,
    visit.admdat,
    visit.admtim,
    visit.refdoc
WHERE 
    patient.patid = visit.patid AND 
    patient.issuer = visit.issuer;
