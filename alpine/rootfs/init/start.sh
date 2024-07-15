#!/bin/sh

# Runs php-fpm
echo "Start the php-fpm service"
php-fpm -R -c /etc/php/fpm/php.ini -y /etc/php/fpm/php-fpm.conf

# Run nginx
echo "Start the nginx service"
nginx -c /etc/nginx/nginx.conf -g 'daemon off;'

# Run cron service
echo "Start the cron service"
crond -f