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

-- IHE Cardiology starting fall 2004
insert into schedule(uniserid, spsindex, spsdes) values
('CATH.001^Cardiac Cath Consultation^ERL_MESA', 40011, 'HD Left Heart Cath')
insert into schedule(uniserid, spsindex, spsdes) values
('CATH.001x^Cardiac Cath Consultation^ERL_MESA', 40012, 'IVUS Left Heart Cath')
insert into schedule(uniserid, spsindex, spsdes) values
('CATH.001x^Cardiac Cath Consultation^ERL_MESA', 40013, 'XA Left Heart Cath')

insert into actionitem(spsindex, codval, codmea, codschdes) values
('40011', 'XX-20011', 'Left Heart Cath', 'DSS_MESA')
-- These next two are not triggred by the spsindex or universal service ID.
-- The Order Filler will add these during Cardiology Cath Workflow.
insert into actionitem(spsindex, codval, codmea, codschdes) values
('40012', 'XX-20012', 'IVUS Left Heart Cath', 'DSS_MESA')
insert into actionitem(spsindex, codval, codmea, codschdes) values
('40013', 'XX-20013', 'XA Left Heart Cath', 'DSS_MESA')
go

-- These are for Echo cases
insert into schedule(uniserid, spsindex, spsdes) values
 ('ECHO.001^TTE^ERL_MESA', 20021, 'TTE')
go

insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('20021', 'XX-20021', 'TTE', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('ECHO.002^STRESS ECHO^ERL_MESA', 20031, 'Stress Echo')
go

insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('20031', 'XX-20031', 'Stress Echo', 'DSS_MESA')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('IMP200^Media Import^ERL_MESA', 4000, 'Import One Step')
go

insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('4000', 'IRWF-200', 'Import One Step', 'DSS_MESA')
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

insert into schedule(uniserid, spsindex, spsdes) values
 ('EYE-200^Generic Eye Procedure 200^IHEDEMO', 6000, 'SPS: Eye Care 200')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('6000', 'EYE_PC_200', 'Protocol Code Item: Eye Care 200', 'IHEDEMO')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2001^Lids Photo - OD^99AAODemo', 5001, 'SPS: Lids 2001')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5001', '2001', 'Lids Photo - OD', '99AAODemo')
go


insert into schedule(uniserid, spsindex, spsdes) values
 ('2001^Lids Photo - OD^99AAODemo', 5001, 'SPS: Lids 2001')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5001', '1', 'Lids Photo - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2002^Lids Photo - OS^99AAODemo', 5002, 'SPS: Lids 2002')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5002', '2', 'Lids Photo - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2003^Iris Photo - OD^99AAODemo', 5003, 'SPS: Iris 2003')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5003', '3', 'Iris Photo - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2004^Iris Photo - OS^99AAODemo', 5004, 'SPS: Iris 2004')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5004', '4', 'Iris Photo - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2005^Cornea Photo - OD^99AAODemo', 5005, 'SPS: Cornea 2005')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5005', '5', 'Cornea Photo - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('2006^Cornea Photo - OS^99AAODemo', 5006, 'SPS: Cornea 2006')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5006', '6', 'Cornea Photo - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3001^30 Deg Center On Disk - OD^99AAODemo', 5007, 'SPS: 30 Deg Center on Disk 3001')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5007', '7', '30 Deg Center On Disk - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3002^30 Deg Center On Disk - OS^99AAODemo', 5008, 'SPS: 30 Deg Center on Disk 3002')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5008', '8', '30 Deg Center On Disk - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3003^45 Deg Center On Disk & Macula - OD^99AAODemo', 5009, 'SPS: 45 Deg Center on Disk 3003')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5009', '9', '45 Deg Center On Disk & Macula - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3004^45 Deg Center On Disk & Macula - OS^99AAODemo', 5010, 'SPS: 45 Deg Center on Disk 3004')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5010', '10', '45 Deg Center On Disk & Macula - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3005^Red Free - OD^99AAODemo', 5011, 'SPS: Red Free 3005')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5011', '11', 'Red Free - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('3006^Red Free - OS^99AAODemo', 5012, 'SPS: Red Free 3006')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5012', '12', 'Red Free - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('4001^Macula - OD^99AAODemo', 5013, 'SPS: Macula 4001')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5013', '13', 'Macula - OD', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('4002^Macula - OS^99AAODemo', 5014, 'SPS: Macula 4002')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5014', '14', 'Macula - OS', '99AAODemo')
go

insert into schedule(uniserid, spsindex, spsdes) values
 ('4003^Macula - OU^99AAODemo', 5015, 'SPS: Macula 4003')
go
insert into actionitem(spsindex, codval, codmea, codschdes) values
 ('5015', '15', 'Macula - OU', '99AAODemo')
go


quit

