#!/bin/bash
exec /etc/init.d/php8.1-fpm start -F && nginx -g daemon off;
