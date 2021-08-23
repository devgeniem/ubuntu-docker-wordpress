FROM devgeniem/ubuntu-docker-openresty-pagespeed:edge2
MAINTAINER Ville Pietarinen, Hannu Kumpula - Geniem Oy <ville.pietarinen-nospam@geniem.com> <hannu-nospam@geniem.com>

##
# Only use these during installation
##
ARG LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

##
# Install php7 packages from dotdeb.org
# - Dotdeb is an extra repository providing up-to-date packages for your Debian servers
##
RUN \
    apt-get update \
&& apt-get -y --no-install-recommends install software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get -y --no-install-recommends install \
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
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        php7.4-dev \
        php7.4-cli \
        php7.4-common \
        php7.4-apcu \
        # php7.4-apcu-bc \
        php7.4-curl \
        php7.4-json \
        php7.4-opcache \
        php7.4-readline \
        php7.4-xml \
        php7.4-zip \
        php7.4-fpm \
        # php7.4-redis \
        php7.4-mongodb \
        php7.4-mysqli \
        php7.4-intl \
        php7.4-gd \
        php7.4-mbstring \
        php7.4-soap \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-ldap \
        php-pear \
        php7.4-imagick \
 
    && pecl install redis \
    # Force install only cron without extra mailing dependencies
    && cd /tmp \
    && apt-get download cron \
    && dpkg --force-all -i cron*.deb \
    && mkdir -p /var/spool/cron/crontabs \
    # Cleanup
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/apt/* /var/log/*.log


# Install helpers
RUN \
    ##
    # Install composer
    ##
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \

    ##
    # Install wp-cli
    # source: http://wp-cli.org/
    ##
    && curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp-cli \
    && chmod +rx /usr/local/bin/wp-cli \
    # Symlink it to /usr/bin as well so that cron can find this script with limited PATH
    && ln -s /usr/local/bin/wp-cli /usr/bin/wp-cli \

    ##
    # Install cronlock for running cron correctly with multi container setups
    # https://github.com/kvz/cronlock
    ##
    && curl -L https://raw.githubusercontent.com/kvz/cronlock/master/cronlock -o /usr/local/bin/cronlock \
    && chmod +rx /usr/local/bin/cronlock \
    # Symlink it to /usr/bin as well so that cron can find this script with limited PATH
    && ln -s /usr/local/bin/cronlock /usr/bin/cronlock

##
# Add Project files like nginx and php-fpm processes and configs
# Also custom scripts and bashrc
##
COPY rootfs/ /

# Run small fixes
RUN set -x \
    && mkdir -p /var/www/uploads \
    && mkdir -p /tmp/php-opcache \
    && ln -sf /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm \
    && ln -sf /usr/bin/wp /usr/local/bin/wp

# This is for your project root
ENV PROJECT_ROOT="/var/www/project"

ENV \
    # Add interactive term
    TERM="xterm" \
    # Set defaults which can be overriden
    MYSQL_PORT="3306" \
    # Use default web port in nginx but allow it to be overridden
    PORT="8080" \
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
    NGINX_FASTCGI_CACHE_VALID_HEADER="200 301 302 404 1m" \
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
    NGINX_INCLUDE_DIR="/var/www/project/nginx" \
    # Allow bigger file uploads
    NGINX_MAX_BODY_SIZE="20M" \
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
    # Intercepted and redirect error greater than 300 to nginx for processing
    FASTCGI_INTERCEPT_ERRORS="on" \
    # PHP settings
    PHP_MEMORY_LIMIT="128M" \
    PHP_MAX_INPUT_VARS="1000" \
    PHP_ERROR_LOG="/proc/self/fd/1" \
    PHP_ERROR_LOG_LEVEL="warning" \
    PHP_ERROR_LOG_MAX_LEN="8192" \
    PHP_SESSION_REDIS_DB="0" \
    PHP_SESSION_HANDLER="files" \
    PHP_PM_MODE="dynamic" \
    PHP_PM_MAX_CHILDREN="25" \
    PHP_PM_START_SERVERS="8" \
    PHP_PM_MIN_SPARE_SERVERS="4" \
    PHP_PM_MAX_SPARE_SERVERS="8" \
    PHP_DISABLE_FUNCTIONS="exec,passthru,shell_exec,show_source,system,pcntl_exec,popen,posix_getpwuid,posix_kill,posix_mkfifo,posix_setpgid,posix_setsid,posix_setuid,posix_setuid,posix_uname,proc_nice,proc_open,proc_close,proc_get_status" \
    # You should count the *.php files in your project and set this number to be bigger
    # $ find . -type f -print | grep php | wc -l
    PHP_OPCACHE_MAX_FILES="8000" \
    # Amount of memory in MB to allocate for opcache
    PHP_OPCACHE_MAX_MEMORY="128" \
    # Use host machine as default SMTP_HOST
    SMTP_HOST="" \
    # This folder is used to mount files into host machine
    # You should use this path for your uploads since everything else should be ephemeral
    UPLOADS_ROOT="/var/www/uploads" \
    # This can be overidden by you, it's just default for us
    TZ="Europe/Helsinki"
# Setup $TZ. Remember to run this again in your own build
    # Make sure that all files here have execute permissions
RUN dpkg-reconfigure tzdata && \
    chmod +x /etc/cont-init.d/*

# Install socklog-overlay
ADD https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/socklog-overlay-amd64.tar.gz -C /
RUN rm /tmp/socklog-overlay-amd64.tar.gz
RUN echo '+\n1' > /etc/socklog.rules/forward-stdout
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale

# Set default path to project folder for easier running commands in project
WORKDIR ${PROJECT_ROOT}
EXPOSE ${PORT}
ENTRYPOINT ["/init"]