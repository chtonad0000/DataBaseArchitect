#!/bin/bash

cd migrations
if [ -z "$MIGRATION_VERSION" ]
then
  for migration_file in $(ls *.sql | sort -V)
  do
    PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -f "$migration_file"
  done
else
  for migration_file in $(ls *.sql | sort -V)
  do
    migration_version=$(echo "$migration_file" | awk -F'.' '{print $1}')
    if [ "$migration_version" -le "$(echo "$MIGRATION_VERSION" | awk -F'.' '{print $1}')" ]
    then
      PGAPASSWORD="$POSTGRES_PASSWORD" psql -p "$POSTGRES_PORT" -d "$POSTGRES_DB" -U "$POSTGRES_USER" -f "$migration_file"
    fi
  done
fi