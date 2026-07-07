#!/bin/bash

DATE=$(date +"%Y%m%d_%H%M%S")

mkdir -p backups

docker exec postgres-db pg_dump -U admin hoteldb > backups/hoteldb_$DATE.sql

echo "Backup Created"
