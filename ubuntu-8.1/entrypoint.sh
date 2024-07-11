#!/bin/bash
/etc/init.d/php8.1-fpm start
/etc/init.d/php8.1-fpm status
whoami
# php-fpm -R -c /etc/php/8.1/fpm/php.ini -y /etc/php/8.1/fpm/fpm-pool.conf
nginx -c /etc/nginx/nginx.conf -g 'daemon off;'