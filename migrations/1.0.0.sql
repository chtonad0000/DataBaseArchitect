CREATE TABLE IF NOT EXISTS season_tickets
(
    ID          serial primary key,
    name        varchar(15),
    price       double precision,
    description varchar(255)
);