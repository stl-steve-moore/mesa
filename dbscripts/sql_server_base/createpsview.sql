create view ps_view
 as select
  patient.patid,
  patient.issuer,
  patient.patid2,
  patient.issuer2,
  patient.nam,
  patient.datbir,
  patient.sex,

  study.stuinsuid,
  study.stuid,
  study.stuorg,
  study.studat,
  study.stutim,
  study.accnum,
  study.refphynam,
  study.studes,
  study.patage,
  study.patsiz,
  study.patsex,
  study.modinstu,
  study.lastmod,
  study.numser,
  study.numins

  from patient, study

  where patient.patid = study.patid

  go

quit

