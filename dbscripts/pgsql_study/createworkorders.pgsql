	create table work_orders (
		ordnum		SERIAL,
		typ		char(20),
		params		char(255),
		ordbyin		char(4),
		datord		int,
		timord		float,
		datcom		int,
		timcom		float,
		elatim		float,
		wortim		float,
		status		int
	);

	create unique index wo_ordnum
	on work_orders(ordnum);

	create index wo_typ
	on work_orders(typ);

	create index wo_ordbyin
	on work_orders(ordbyin);

	create index wo_datord
	on work_orders(datord);

	create index wo_datcom
	on work_orders(datcom);

	create index wo_status
	on work_orders(status);



