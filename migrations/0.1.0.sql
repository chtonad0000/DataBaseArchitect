CREATE TABLE IF NOT EXISTS clients
(
    ID         serial primary key,
    name       varchar(15),
    surname    varchar(15),
    birth_date date
);

