delete from schedule
go
delete from actionitem
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P1^Procedure 1^ERL_MESA', 10, 'P1 10')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('10', 'X1_A1', 'SP Action Item X1_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P2^Procedure 2^ERL_MESA', 20, 'P2 20')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('20', 'X2_A1', 'SP Action Item X2_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P3^Procedure 3^ERL_MESA', 30, 'P3 30')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('30', 'X3A_A1', 'SP Action Item X3A_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P3^Procedure 3^ERL_MESA', 31, 'P3 31')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('31', 'X3B_A1', 'SP Action Item X3B_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P4^Procedure 4^ERL_MESA', 40, 'P4 40')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('40', 'X4A_A1', 'SP Action Item X4A_A1', 'DSS_MESA')
go

 insert into schedule(uniserid, spsindex, spsdes) values
  ('P4^Procedure 4^ERL_MESA', 41, 'P4 41')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('41', 'X4B_A1', 'SP Action Item X4B_A1', 'DSS_MESA')
go

-- This has been commented out for some time; we don't want this extra row.
-- insert into schedule(uniserid, spsindex, spsdes) values
--  ('P4^Procedure 4B^ERL_MESA', 42, 'P4 42')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('41', 'X4B_A2', 'SP Action Item X4B_A2', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P5^Procedure 5^ERL_MESA', 50, 'P5 50')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('50', 'X5_A1', 'SP Action Item X5_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P6^Procedure 6^ERL_MESA', 60, 'P6 60')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('60', 'X6_A1', 'SP Action Item X6_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P7^Procedure 7^ERL_MESA', 70, 'P7 70')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('70', 'X7_A1', 'SP Action Item X7_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P8^Procedure 8^ERL_MESA', 80, 'P8 80')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('80', 'X8A_A1', 'SP Action Item X8A_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P8^Procedure 8^ERL_MESA', 81, 'P8 81')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('81', 'X8B_A1', 'SP Action Item X8B_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P10^Procedure 10^ERL_MESA', 100, 'P10 100')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('100', 'X10_A1', 'SP Action Item X10_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P20^Procedure 20^ERL_MESA', 200, 'P20 200')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('200', 'X20_A1', 'SP Action Item X20_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P21^Procedure 21^ERL_MESA', 210, 'P21 210')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('210', 'X21_A1', 'SP Action Item X21_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P22^Procedure 22^ERL_MESA', 220, 'P22 220')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('220', 'X22_A1', 'SP Action Item X22_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P23^Procedure 23^ERL_MESA', 230, 'P23 230')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('230', 'X23_A1', 'SP Action Item X23_A1', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P101^Mammography Screening^ERL_MESA', 1010, 'P101 Mammography Screening')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('1010', 'X101_A1', 'SP X101 MG Screening', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('P102^Procedure 102^ERL_MESA', 1020, 'P102 3D CT Reconstruction')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('1020', 'X102_A1', 'SP X102 CT 3D Reconstruction', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('IMP200^Media Import^ERL_MESA', 4000, 'Import One Step')
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('4000', 'IRWF-200', 'Import One Step', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('STRESS.001^12-Lead ECG^ERL_MESA', 5000, '12-Lead ECG')                                                                                
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5000', 'P2-7131C', 'Balke Protocol', 'SRT')
insert into schedule(uniserid, spsindex, spsdes) values
 ('STRESS.002^General ECG^ERL_MESA', 5000, 'General ECG') 
go

