CREATE TABLE IF NOT EXISTS hall_entry
(
    client_id  integer,
    hall_id    integer,
    enter_time timestamp,
    exit_time  timestamp,
    primary key (client_id, enter_time),
    foreign key (hall_id) references halls (ID)
);