	create table ordr (
        plaordnum	varchar(22),
		filordnum	varchar(22),
		uniserid	varchar(200),
		visnum		varchar(20),
		orduid		SERIAL UNIQUE,
		ordcon		varchar(2),
		plagronum	varchar(22),
		ordsta		varchar(2),
		messta		varchar(20),
		quatim		varchar(32),
		par		varchar(200),
		dattimtra	varchar(26),
		entby		varchar(192),
		ordpro		varchar(192),
		refdoc		varchar(192),
		ordeffdattim	varchar(14),
		entorg		varchar(60),
		spesou		varchar(64),
		ordcalphonum	varchar(16),
		traarrres	varchar(20),
		reaforstu	varchar(192),
		obsval		varchar(20),
		dancod		varchar(60),	
		relcliinf	varchar(64)
	);

	create index plaordnum_index
	on ordr(plaordnum);

	create index filordnum_index
	on ordr(filordnum);
