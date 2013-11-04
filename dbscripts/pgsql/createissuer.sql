create table issuer (
	issuer_key	serial PRIMARY KEY,
	issuer		varchar(100),
	UNIQUE(issuer)
);
