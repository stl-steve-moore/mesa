create view sopins_view
 as select
  patient.patid,
  patient.issuer,
  patient.patid2,
  patient.issuer2,
  patient.nam,
  patient.datbir,
  patient.sex,

  study.stuinsuid,
  series.serinsuid,
  sopins.filnam
  
  from patient, study, series, sopins

  where patient.patid = study.patid
  and series.stuinsuid = study.stuinsuid
  and sopins.serinsuid = series.serinsuid;
