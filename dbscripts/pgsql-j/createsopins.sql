	create table sopins (
		serinsuid	char(64),
		clauid		char(64),
		insuid		char(64),
		imanum		char(16),
		row		char(8),
		col		char(8),
		bitall		char(8),
		numfrm		char(8),
		prelbl		char(16),
		predes		char(64),
		precredat	char(8),
		precretim	char(16),
		precrenam	char(64),
		comflg		char(16),
		verflg		char(16),
		condat		char(8),
		contim		char(16),
		obsdattim	char(24),
		conceptval	char(16),
		conceptschm	char(16),
		conceptvers	char(16),
		conceptmean	char(64),
		filnam		char(255)
	);

	create index sopinsuid_sopins
	on sopins(insuid);
