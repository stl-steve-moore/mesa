	create table mpps (
		patnam		char(64),
		patid		char(20),
		patbirdat	char(8),
		patsex		char(4),
		ppsid		char(64),
		perstaaetit	char(64),
		perstanam	char(64),
		perloc		char(64),
		ppsstadat	char(8),
		ppsstatim	char(20),
                ppssta		char(64),
                ppsdes		char(64),
                pptypdes	char(64),
                ppsenddat	char(8),
                ppsendtim	char(6),
                mod		char(16),
                stuid		char(64),
                perserseq	char(64),
                schsteattseq	char(64),
                refstucomseq	char(64)
	)
	go

	create index ppsid_index
	on mpps(ppsid)
	go

quit

