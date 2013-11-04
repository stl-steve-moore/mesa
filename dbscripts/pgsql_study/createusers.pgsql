	create table users (
		ini		char(4),
		nam		char(64),
		dep		char(64),
		phonum		char(20),
		ema		char(100),
		lasupd		int,
		status		char(8)
	);
	
	create unique index ini_users
	on users(ini);
