ARG ALPINE_VERSION="3.20"
ARG PHP_VERSION="8.1"
ARG PHP_EXTENSION_INSTALLER_VERSION="2.1.7"
ARG COMPOSER_VERSION="2.5.4"

ARG RESTY_VERSION="1.19.9.1"
ARG RESTY_OPENSSL_VERSION="1.1.1k"
ARG PAGESPEED_VERSION="1.13.35.2"

ARG NGINX_VERSION="1.23.3"

# Fix apt-get and show colors
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm-color

FROM alpine:${ALPINE_VERSION} AS base
RUN apk  --no-cache add \
    ca-certificates \
    musl-dev \
    nano \
    apt-utils \
    curl \
    nano \
    ca-certificates \
    git \
    mysql-client \
    msmtp \
    postfix \
    netcat \
    less \
    build-essential \
    cron

FROM nginx:${NGINX_VERSION}-alpine AS nginx
FROM mlocati/php-extension-installer:${PHP_EXTENSION_INSTALLER_VERSION} AS php-extension-installer
FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} AS php

FROM php AS runtime-base
RUN apk add --no-cache pcre2 pcre-dev $PHPIZE_DEPS

COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    curl \
    mysqli \
    mongodb \
    pdo_mysql \
    apcu \
    opcache \
    readline \
    xml \
    zip \
    bcmath \
    exif \
    gd \
    intl \
    soap \
    gettext \
    mbstring \
    soap \
    bcmath \
    ldap \
    imagick \
    redis

ENV \
    # Add interactive term
    TERM="xterm" \
    # Set defaults which can be overriden
    MYSQL_PORT="3306" \
    # Use default web port in nginx but allow it to be overridden
    PORT="8080" \
    INTERNAL_PORT="8888" \
    # Main server listen interface, set to 0.0.0.0 along with NGINX_INTERNAL_PROXY_INCLUDE="" & INTERNAL_PORT="$PORT" to disable internal proxy
    INTERNAL_HOST="127.0.0.1" \
    # Use custom users for nginx and php-fpm
    WEB_USER="wordpress" \
    WEB_GROUP="web" \
    WEB_UID=1000 \
    WEB_GID=1001 \
    # Set defaults for redis
    REDIS_PORT="6379" \
    REDIS_DATABASE="0" \
    REDIS_PASSWORD="" \
    REDIS_SCHEME="tcp" \
    # Set defaults for NGINX fastcgi cache
    # This variable uses seconds by default
    # Time units supported are "s"(seconds), "ms"(milliseconds), "y"(years), "M"(months), "w"(weeks), "d"(days), "h"(hours), and "m"(minutes).
    # Also http response codes that are cached can be set
    NGINX_FASTCGI_CACHE_VALID="200 404 1m" \
    # Default fastcgi cache directory
    NGINX_FASTCGI_CACHE_DIRECTORY="/tmp/nginx/fullpage" \
    # Default fastcgi cache size
    NGINX_FASTCGI_CACHE_MAX_SIZE="1000m" \
    # Default operations when fastcgi stale cache is used
    NGINX_FASTCGI_CACHE_USE_STALE="error timeout invalid_header updating http_500 http_503 http_403 http_404 http_429" \
    # Default headers for fastcgi stale- and error cache
    NGINX_FASTCGI_CACHE_CONTROL='"max-age=60, stale-while-revalidate=300, stale-if-error=21600"'\
    NGINX_CACHE_CONTROL='"max-age=60, stale-while-revalidate=300, stale-if-error=21600"'\
    #Default time for fastcgi cache path inactive attribute
    NGINX_FASTCGI_CACHE_INACTIVE="730h" \
    #Fastcgi default value for updating cache on background
    NGINX_FASTCGI_CACHE_BACKGROUND_UPDATE="on" \
    # Cronlock is used to stop simultaneous cronjobs in clusterised environments
    CRONLOCK_HOST="" \
    # This is used by nginx and php-fpm
    WEB_ROOT="${PROJECT_ROOT}/web" \
    # This is used automatically by wp-cli
    WP_CORE="${PROJECT_ROOT}/web/wp" \
    # Nginx include files
    NGINX_INCLUDE_DIR="/tmp/nginx-conf-project" \
    # Allow bigger file uploads
    NGINX_MAX_BODY_SIZE="20M" \
    # Nginx rlimit config include, set to empty to disable
    NGINX_WORKER_RLIMIT_INCLUDE="include worker_rlimit.conf;" \
    # Nginx proxy for main server include, set to empty to disable, along with INTERNAL_HOST="0.0.0.0" & INTERNAL_PORT="$PORT"
    NGINX_INTERNAL_PROXY_INCLUDE="include internal_proxy.conf;" \
    # Empty these envs to disable fastcgicache fully
    NGINX_FASTCGICACHE_DEFAULT_KEY="fastcgi_cache_key \$scheme\$request_method\$host\$uri\$cache_args\$custom_parameters\$state;" \
    NGINX_FASTCGICACHE_PURGE_LOCATION_INCLUDE="include cache/purge_location.conf;" \
    NGINX_FASTCGICACHE_SETTINGS_INCLUDE="include cache/fastcgicache_settings.conf;" \
    NGINX_FASTCGICACHE_HEADERS_INCLUDE="include cache/fastcgicache_headers.conf;" \
    NGINX_FASTCGICACHE_INCLUDE="include cache/fastcgicache.conf;" \
    # Nginx events { worker_connections }
    NGINX_WORKER_CONNECTIONS="8000" \
    # Allow storing bigger body in memory
    NGINX_BODY_BUFFER_SIZE="10M" \
    # Have sane fastcgi timeout by default
    NGINX_FASTCGI_TIMEOUT="30" \
    # Have sane fastcgi timeout by default
    NGINX_ERROR_LEVEL="warn" \
    # Have sane fastcgi timeout by default
    NGINX_ERROR_LOG="/dev/stderr" \
    # Have sane fastcgi timeout by default
    NGINX_ACCESS_LOG="/dev/stdout" \
    # Set nginx fastcgi buffers
    NGINX_FASTCGI_BUFFERS="16 16k" \
    NGINX_FASTCGI_BUFFER_SIZE="16k" \
    NGINX_FASTCGI_BUSY_BUFFERS_SIZE="16k" \
    # Intercepted and redirect error greater than 300 to nginx for processing
    FASTCGI_INTERCEPT_ERRORS="on" \
    # PHP settings
    PHP_MEMORY_LIMIT="512M" \
    PHP_MAX_INPUT_VARS="1000" \
    PHP_ERROR_LOG="/dev/stderr" \
    PHP_ERROR_LOG_LEVEL="warning" \
    PHP_ERROR_LOG_MAX_LEN="8192" \
    PHP_SESSION_REDIS_DB="0" \
    PHP_SESSION_HANDLER="files" \
    PHP_PM_MODE="dynamic" \
    PHP_PM_MAX_CHILDREN="25" \
    PHP_PM_MAX_SPAWN_RATE="25" \
    PHP_PM_START_SERVERS="8" \
    PHP_PM_MIN_SPARE_SERVERS="4" \
    PHP_PM_MAX_SPARE_SERVERS="8" \
    PHP_DISABLE_FUNCTIONS="exec,passthru,shell_exec,show_source,system,pcntl_exec,popen,posix_getpwuid,posix_kill,posix_mkfifo,posix_setpgid,posix_setsid,posix_setuid,posix_setuid,posix_uname,proc_nice,proc_open,proc_close,proc_get_status" \
    # You should count the *.php files in your project and set this number to be bigger
    # $ find . -type f -print | grep php | wc -l
    PHP_OPCACHE_MAX_FILES="8000" \
    # Amount of memory in MB to allocate for opcache
    PHP_OPCACHE_MAX_MEMORY="128" \
    PHP_PM_PROCESS_IDLE_TIMEOUT="10s" \
    PHP_PM_MAX_REQUESTS="500" \
    # set to "unlimited" for coredumps along with settings process.dumpable = yes in php-fpm.d/coredumps.conf
    PHP_RLIMIT_CORE="0" \
    PHP_PING_PATH="/ping" \
    PHP_EMERGENCY_RESTART_THRESHOLD="2" \
    PHP_EMERGENCY_RESTART_INTERVAL="20s" \
    PHP_PROCESS_CONTROL_TIMEOUT="10s" \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER="16" \
    # Use host machine as default SMTP_HOST
    SMTP_HOST="" \
    # This folder is used to mount files into host machine
    # You should use this path for your uploads since everything else should be ephemeral
    UPLOADS_ROOT="/var/www/uploads" \
    # This can be overidden by you, it's just default for us
    TZ="Europe/Helsinki" \
    # Default endpoint for docker healthcheck, a better option can be wp-json if not restricted
    DOCKER_HEALTHCHECK_PATH="/ping"


COPY --from=nginx /usr/sbin/nginx /usr/sbin/nginx
COPY --from=nginx /etc/nginx /etc/nginx
COPY --from=nginx /usr/lib/nginx /usr/lib/nginx
COPY --from=nginx /usr/local/bin/envsubst /usr/bin/envsubst
RUN mkdir -p /var/log/nginx && \
    mkdir -p /var/cache/nginx/client_temp
RUN addgroup -g 101 -S nginx && \
    adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx


# This is for your project root
ENV PROJECT_ROOT="/var/www/project"

COPY rootfs /
RUN rm -rf rootfs

COPY /config /app/config

COPY /web/* /var/www/project/
RUN rm -rf web/

FROM runtime-base AS builder
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV CPPFLAGS="-DPNG_ARM_NEON_OPT=0"
RUN apk --no-cache add nodejs npm gulp
RUN apk --no-cache add \
    build-base libc6-compat autoconf automake libtool \
    pkgconf nasm libpng-dev zlib-dev libimagequant-dev
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

FROM runtime-base as project
# Set default path to project folder for easier running commands in project
WORKDIR ${PROJECT_ROOT}
EXPOSE ${PORT}
HEALTHCHECK --interval=10s --retries=3 --start-period=10s --timeout=3s CMD /healthcheck

FROM runtime-base as runtime
WORKDIR /var/www/project
COPY . .
RUN cat tasks.cron > /etc/crontabs/root
RUN chmod +x /init/start.sh
ENTRYPOINT [ "/init/start.sh" ]
