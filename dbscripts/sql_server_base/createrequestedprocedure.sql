	create table reqprocedure (
		stuinsuid	char(64),
		reqproid	char(30),
		filordnum	char(22),
		accnum		char(20),
		quatim		char(32),
		everea		char(20),
		reqdattim	char(20),
		spesou		char(20),
		ordpro		char(64),
		refdoc		char(64),
		reqprodes	char(64),
		reqprocod	char(30),
		occnum		char(20),
		apptimqua	char(30),
		orduid		char(20)
	)
	go

	create index reqproid_index
	on reqprocedure(reqproid)
	go


quit

