CREATE TABLE IF NOT EXISTS coaches_in_hall
(
    coach_id   integer,
    start_time timestamp,
    hall_id    integer,
    end_time timestamp,
    primary key (coach_id, start_time),
    foreign key (coach_id) references coaches (ID),
    foreign key (hall_id) references halls (ID)
);