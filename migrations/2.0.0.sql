CREATE TABLE IF NOT EXISTS subscription
(
    client_id        integer,
    season_ticket_id integer,
    start_time       timestamp,
    end_time         timestamp,
    primary key (client_id, season_ticket_id, start_time),
    foreign key (client_id) references clients (ID),
    foreign key (season_ticket_id) references season_tickets (ID)
);
