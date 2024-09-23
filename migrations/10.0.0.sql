CREATE TABLE IF NOT EXISTS sports_equipment_subcategory
(
    ID          serial primary key,
    name        varchar(20),
    category_id integer,
    foreign key (category_id) references sports_equipment_category (ID)
);