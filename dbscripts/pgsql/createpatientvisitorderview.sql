create view patient_visit_order AS SELECT
	patient.patid,
    patient.nam, 
    patient.issuer, 
    patient.datbir, 
	patient.sex,
	patient.patrac,
	patient.addr,
	patient.pataccnum,
	visit.patcla,
	visit.asspatloc,
	visit.attdoc,
	visit.refdoc,
	visit.admdoc,
    visit.admdat, 
    visit.admtim,
    visit.visnum,
    ordr.uniserid,
    ordr.orduid,
    ordr.traarrres,
    ordr.relcliinf,
    ordr.ordcon,
    ordr.ordsta,
    ordr.ordpro,
    ordr.dattimtra,
    ordr.entby,
    ordr.ordcalphonum,
    ordr.ordeffdattim,
    ordr.entorg
WHERE 
    visit.visnum = ordr.visnum AND
    patient.patid = visit.patid AND 
    patient.issuer = visit.issuer;
