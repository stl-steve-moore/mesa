create table hl7_destination (
	dest_id     serial PRIMARY KEY,
    hostname    varchar(64),
    port        int,
    rec_fac_nam varchar(32),
    rec_app     varchar(32),
    com_nam     varchar(32),
    actor_type  varchar(16)
);

create index actor_index
on hl7_destination(actor_type);
