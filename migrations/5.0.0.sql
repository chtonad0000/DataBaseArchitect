CREATE TABLE IF NOT EXISTS halls
(
    ID               serial primary key,
    sports_type_id   integer,
    capacity         integer,
    current_capacity integer,
    state            varchar(255),
    foreign key (sports_type_id) references sports_types (ID)
);