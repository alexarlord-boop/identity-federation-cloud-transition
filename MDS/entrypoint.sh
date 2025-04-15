#!/bin/bash

cd /opt/rr3

# Wait for MySQL
while ! mysqladmin ping -hdb -urr3user -prr3pass --silent; do
    sleep 1
done

if [ ! -f application/config/database.php ]; then
  echo "Configuration files missing!"
  exit 1
fi

echo "Running Doctrine setup..."
cd application
./doctrine orm:schema-tool:update --force
./doctrine orm:generate-proxies

echo "Starting Apache..."
exec apache2-foreground