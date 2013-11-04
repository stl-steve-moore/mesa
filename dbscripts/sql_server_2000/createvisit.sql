	create table visit (
		visnum		char(20),
		patid		char(20),
		issuer		char(100),
		patcla		char(20),
		asspatloc	char(64) NULL,
		attdoc		char(64) NULL,
		admdoc		char(64) NULL,
		admdat		char(8),
		admtim		char(8),
		presta		char(20) NULL,
		refdoc		char(64) NULL
	)
	go

	create index visnum_index
	on visit(visnum)
	go
