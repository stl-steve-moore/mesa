	create table ordr (
                plaordnum	char(22),
		filordnum	char(22),
		uniserid	char(200),
		visnum		char(20),
		orduid		int identity,
		ordcon		char(2),
		plagronum	char(22),
		ordsta		char(2),
		messta		char(20),
		quatim		char(32),
		par		char(200),
		dattimtra	char(26),
		entby		char(64),
		ordpro		char(64),
		refdoc		char(64),
		ordeffdattim	char(14),
		entorg		char(60),
		spesou		char(64),
		ordcalphonum	char(16),
		traarrres	char(20),
		reaforstu	char(64),
		obsval		char(20),
		dancod		char(60),	
		relcliinf	char(64)
	)
	go

	create index plaordnum_index
	on ordr(plaordnum)
	go

	create index filordnum_index
	on ordr(filordnum)
	go


quit

