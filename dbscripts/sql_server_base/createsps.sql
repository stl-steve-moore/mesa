	create table sps (
		spsid		char(16),
		schaet		char(16),
		spsstadat	char(8),
		spsstatim	char(16),
		mod		char(16),
		schperphynam	char(64),
		spsdes		char(64),
		spsloc		char(16),
		premed		char(64),
		reqconage	char(64),
		schstanam	char(16),
		stuinsuid	char(64),
		spssta		char(16)
	)
	go

	create index spsid_index
	on sps(spsid)
	go

quit

