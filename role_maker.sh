#!/bin/bash

POSTGRES_DB="postgres"
POSTGRES_USER="postgres"
NAMES=("user1" "user2" "user3")

PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE ROLE reader;"
PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;"

PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE ROLE writer;"
PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO writer;"

PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE USER analytic;"
PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "GRANT SELECT ON subscription TO analytic;"

PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE ROLE group_role NOLOGIN;"
PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "GRANT USAGE ON SCHEMA public TO group_role;"
for name in "${NAMES[@]}"; do
    PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "CREATE USER $name;"
    PGPASSWORD="postgres" psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" -c "GRANT group_role TO $name;"
done
