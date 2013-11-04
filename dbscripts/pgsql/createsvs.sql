
create table svs (
	id		serial PRIMARY KEY,
	svs_id		text not null,
	version		text,
	lang		char(32),
	path		text,
	path_root	text
);

