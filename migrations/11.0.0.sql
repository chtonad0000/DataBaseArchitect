CREATE TABLE IF NOT EXISTS sports_equipment
(
    ID             serial primary key,
    name           varchar(20),
    subcategory_id integer,
    factory_name   varchar(20),
    foreign key (subcategory_id) references sports_equipment_subcategory (ID)
);