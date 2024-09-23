CREATE TABLE IF NOT EXISTS hall_sports_equipment
(
    hall_id             integer,
    sports_equipment_id integer,
    amount              integer,
    primary key (hall_id, sports_equipment_id),
    foreign key (hall_id) references halls (ID),
    foreign key (sports_equipment_id) references sports_equipment (ID)
);