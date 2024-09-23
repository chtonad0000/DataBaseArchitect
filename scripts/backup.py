import os
import time
import subprocess
from datetime import datetime

DB_NAME = os.getenv('POSTGRES_DB')
DB_USER = os.getenv('POSTGRES_USER')
DB_PASSWORD = os.getenv('POSTGRES_PASSWORD')
DB_HOST = os.getenv('POSTGRES_HOST')
DB_PORT = os.getenv('POSTGRES_PORT')

BACKUP_INTERVAL_HOURS = int(os.getenv('BACKUP_INTERVAL_HOURS'))
BACKUP_RETAIN_COUNT = int(os.getenv('BACKUP_RETAIN_COUNT'))
BACKUP_DIR = "/app/backups"

PG_DUMP_PATH = "/usr/bin/pg_dump"

def create_backup():
    timestamp = datetime().nowstrftime('%Y%m%d%H%M%S')
    backup_filename = f"/app/backups/backup_{timestamp}.sql"
    command = [
        PG_DUMP_PATH,
        f'--dbname=postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}',
        '--file', backup_filename
    ]

    try:
        subprocess.run(command, check=True)
        print(f"Backup created: {backup_filename}")
    except subprocess.CalledProcessError as e:
        print(f"Error creating backup: {e}")


def delete_old_backups():
    backups = sorted(
        [f for f in os.listdir(BACKUP_DIR) if f.startswith('backup_')],
        key=lambda f: os.path.getmtime(os.path.join(BACKUP_DIR, f))
    )

    while len(backups) > BACKUP_RETAIN_COUNT:
        oldest_backup = backups.pop(0)
        os.remove(os.path.join(BACKUP_DIR, oldest_backup))
        print(f"Deleted old backup: {oldest_backup}")


if __name__ == "__main__":
    while True:
        create_backup()
        delete_old_backups()
        time.sleep(BACKUP_INTERVAL_HOURS * 3600)
