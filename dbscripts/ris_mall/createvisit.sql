	create table visit (
		viskey   serial PRIMARY KEY,
		visnum		varchar(20),
		patid		varchar(20),
		issuer		varchar(128),
		patcla		varchar(20),
		asspatloc	varchar(64),
		attdoc		varchar(64),
		admdoc		varchar(64),
		admdat		varchar(8),
		admtim		varchar(8),
		presta		varchar(20),
		refdoc		varchar(64)
	);

	create index visnum_index
	on visit(visnum);
