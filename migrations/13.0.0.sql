CREATE TABLE IF NOT EXISTS training_history
(
    client_id           integer,
    start_time          timestamp,
    end_time            timestamp,
    sports_equipment_id integer,
    hall_id             integer,
    primary key (client_id, start_time),
    foreign key (client_id) references clients (ID),
    foreign key (sports_equipment_id) references sports_equipment (ID),
    foreign key (hall_id) references halls (ID)
);