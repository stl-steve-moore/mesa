	create table visit (
		visnum		char(20),
		patid		char(20),
		issuer		char(100),
		patcla		char(20),
		asspatloc	char(64),
		attdoc		char(64),
		admdat		char(8),
		admtim		char(8),
		presta		char(20),
		refdoc		char(64),
		admdoc		char(64)
	);

	create index visnum_index
	on visit(visnum);
