#!/bin/bash
if [ -z "$RECORDS_COUNT" ]; then
  RECORDS_COUNT=1000
fi

start_date=$(date -d "1970-01-01")

names=()
for ((i=1; i<=100; i++)); do
    name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
    names+=("$name")
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  name=${names[$((RANDOM % ${#names[@]}))]}
  surname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
  birth_date=$(date -d "$start_date + $i days")
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO clients (name, surname, birth_date) VALUES ('$name', '$surname', '$birth_date');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  name=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
  price="$(awk -v min="1000.0" -v max="10000.0" \ 'BEGIN{srand(); print min+rand()*(max-min)}')"
  description=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO season_tickets (name, price, description) VALUES ('$name', $price, '$description');"
done

ids=()
for ((i=1; i<="$RECORDS_COUNT"; i++)); do
    ids+=("$i")
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_client_id=${ids[$((RANDOM % ${#ids[@]}))]}
  random_season_ticket_id=${ids[$((RANDOM % ${#ids[@]}))]}
  start_time=$(date -d "2023-04-04 + $((RANDOM % 50 + 1)) days" +"%Y-%m-%d")
  end_time=$(date -d "$start_time + $((RANDOM % 30 + 1)) days" +"%Y-%m-%d")
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO subscription (client_id, season_ticket_id, start_time, end_time) VALUES ('$random_client_id', '$random_season_ticket_id', '$start_time', '$end_time');"
done

for ((i = 1; i <= 100; i++)); do
  name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO sports_types (name) VALUES ('$name');"
done

sports_types_ids=()
for ((i=1; i<=100; i++)); do
    sports_types_ids+=("$i")
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_sport_id=${sports_types_ids[$((RANDOM % ${#sports_types_ids[@]}))]}
  random_season_ticket_id=${ids[$((RANDOM % ${#ids[@]}))]}
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO sports_in_season_tickets (sports_type_id, season_ticket_id) VALUES ('$random_sport_id', '$random_season_ticket_id');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  name=${names[$((RANDOM % ${#names[@]}))]}
  surname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
  random_sport_id=${sports_types_ids[$((RANDOM % ${#sports_types_ids[@]}))]}
  state=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 25 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO coaches (name, surname, sports_type_id, state) VALUES ('$name', '$surname', '$random_sport_id', '$state');"
done

category_ids=()
for ((i=1; i<=100; i++)); do
    category_ids+=("$i")
done

for ((i = 1; i <= 100; i++)); do
  name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO sports_equipment_category (name) VALUES ('$name');"
done

for ((i = 1; i <= 1000; i++)); do
  name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
  random_sport_category_id=${category_ids[$((RANDOM % ${#category_ids[@]}))]}
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO sports_equipment_subcategory (name, category_id) VALUES ('$name', '$random_sport_category_id');"
done

subcategory_ids=()
for ((i=1; i<=1000; i++)); do
    subcategory_ids+=("$i")
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
  random_sport_subcategory_id=${subcategory_ids[$((RANDOM % ${#subcategory_ids[@]}))]}
  factory_name=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 20 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO sports_equipment (name, subcategory_id, factory_name) VALUES ('$name', '$random_sport_subcategory_id', '$factory_name');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_sport_id=${sports_types_ids[$((RANDOM % ${#sports_types_ids[@]}))]}
  capacity=$((($RANDOM % (100 - 10 + 1)) + 10))
  current_capacity=$((($RANDOM % (100 - 10 + 1)) + 10))
  state=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 25 | head -n 1)
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO halls (sports_type_id, capacity, current_capacity, state) VALUES ('$random_sport_id', '$capacity' ,'$current_capacity', '$state');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_coach_id=${ids[$((RANDOM % ${#ids[@]}))]}
  start_time=$(date -d "2023-05-04 + $((RANDOM % 30 + 1)) days" +"%Y-%m-%d")
  random_hall_id=${ids[$((RANDOM % ${#ids[@]}))]}
  end_time=$(date -d "$start_time + $((RANDOM % 30 + 1)) days" +"%Y-%m-%d")
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO coaches_in_hall (coach_id, start_time, hall_id, end_time) VALUES ('$random_coach_id', '$start_time', '$random_hall_id', '$end_time');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_client_id=${ids[$((RANDOM % ${#ids[@]}))]}
  random_hall_id=${ids[$((RANDOM % ${#ids[@]}))]}
  start_time=$(date -d "2023-05-04 + $((RANDOM % 30 + 1)) days $((RANDOM % 12)) hours" +"%Y-%m-%d %H:%M:%S")
  end_time=$(date -d "$start_time + $((RANDOM % 3)) hours" +"%Y-%m-%d %H:%M:%S")
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO hall_entry (client_id, hall_id, enter_time,exit_time) VALUES ('$random_client_id', '$random_hall_id', '$start_time', '$end_time');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_sports_equipment_id=${ids[$((RANDOM % ${#ids[@]}))]}
  random_hall_id=${ids[$((RANDOM % ${#ids[@]}))]}
  amount=$((($RANDOM % (50 - 10 + 1)) + 10))
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO hall_sports_equipment (hall_id, sports_equipment_id, amount) VALUES ('$random_hall_id', '$random_sports_equipment_id', '$amount');"
done

for ((i = 1; i <= RECORDS_COUNT; i++)); do
  random_client_id=${ids[$((RANDOM % ${#ids[@]}))]}
  start_time=$(date -d "2023-05-04 + $((RANDOM % 30 + 1)) days $((RANDOM % 12)) hours" +"%Y-%m-%d %H:%M:%S")
  end_time=$(date -d "$start_time + $((RANDOM % 3)) hours" +"%Y-%m-%d %H:%M:%S")
  random_sports_equipment_id=${ids[$((RANDOM % ${#ids[@]}))]}
  random_hall_id=${ids[$((RANDOM % ${#ids[@]}))]}
  PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "INSERT INTO training_history (client_id, start_time, end_time, sports_equipment_id, hall_id) VALUES ('$random_client_id', '$start_time', '$end_time', '$random_sports_equipment_id', '$random_hall_id');"
done

