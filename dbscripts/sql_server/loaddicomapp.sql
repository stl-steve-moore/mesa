delete from dicomapp
go

insert into dicomapp (aet, host, port, org, com) values 
 ('MESA_MOD', 'modality1', 2400, 'ERL', 'Modality Simulator')

insert into dicomapp (aet, host, port, org, com) values 
 ('MODALITY1', 'modality1', 2400, 'ERL', 'Modality Simulator')

insert into dicomapp (aet, host, port, org, com) values 
 ('MODALITY2', 'modality2', 2500, 'ERL', 'Modality Simulator')

insert into dicomapp (aet, host, port, org, com) values 
 ('WORKSTATION1', 'workstation1', 3001, 'ERL', 'Workstation Storage')

insert into dicomapp (aet, host, port, org, com) values 
 ('WORKSTATION2', 'workstation2', 3002, 'ERL', 'Workstation Simulator')
go
