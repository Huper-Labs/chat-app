#!/bin/bash

# Set backup directory with timestamp
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Stop services to ensure data consistency
echo "Stopping services for backup..."
docker compose stop

# Backup postgres database
echo "Backing up PostgreSQL database..."
docker compose run --rm postgres pg_dumpall -U postgres > "$BACKUP_DIR/postgres_backup.sql"

# Backup volume directories
echo "Backing up volume data..."
tar -czf "$BACKUP_DIR/volumes_backup.tar.gz" volumes/

# Backup configuration
echo "Backing up configuration..."
tar -czf "$BACKUP_DIR/config_backup.tar.gz" config/

# Restart services
echo "Restarting services..."
docker compose up -d

echo "Backup complete! Files saved to: $BACKUP_DIR"