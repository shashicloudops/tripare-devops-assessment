#!/bin/bash

LATEST=$(ls -t backups/*.sql | head -1)

docker exec -i postgres-db psql -U admin -c "DROP DATABASE IF EXISTS hoteldb;"

docker exec -i postgres-db psql -U admin -c "CREATE DATABASE hoteldb;"

cat $LATEST | docker exec -i postgres-db psql -U admin hoteldb

echo "Restore Complete"
