CREATE TABLE IF NOT EXISTS coaches
(
    ID             SERIAL primary key,
    name           varchar(15),
    surname        varchar(15),
    sports_type_id integer,
    state          varchar(30),
    foreign key (sports_type_id) references sports_types (ID)
);