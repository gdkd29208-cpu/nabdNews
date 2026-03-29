#!/bin/sh
set -eu

mkdir -p /var/www/html/database
touch /var/www/html/database/database.sqlite

mkdir -p /var/www/html/storage/framework/cache/data
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/logs

chown -R www-data:www-data /var/www/html/storage /var/www/html/database

php artisan optimize:clear
php artisan migrate --force
php artisan storage:link || true

exec /usr/bin/supervisord -c /etc/supervisord.conf
