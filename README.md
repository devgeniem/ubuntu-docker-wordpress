# ubuntu-docker-wordpress

WordPress runtime: OpenResty + PHP 8.3 FPM + cron, supervised by s6 and configured via env vars.

Layer 3 of 3 in the devgeniem web image stack:
1. [docker-base](https://github.com/devgeniem/docker-base): Ubuntu + s6 base
2. [ubuntu-docker-openresty-pagespeed](https://github.com/devgeniem/ubuntu-docker-openresty-pagespeed): OpenResty
3. **[ubuntu-docker-wordpress](https://github.com/devgeniem/ubuntu-docker-wordpress)**: PHP-FPM + WordPress tooling

## Includes
- PHP 8.3 FPM (redis, apcu, imagick, mongodb)
- composer, wp-cli
- cron + [cronlock](https://github.com/kvz/cronlock), msmtp

## Usage
```bash
docker run -p 8080:8080 -v "$PWD":/var/www/project devgeniem/ubuntu-docker-wordpress
```
Docroot is `web/`. Defaults for env vars (`PORT`, `NGINX_*`, `PHP_*`, `REDIS_*`, `SMTP_HOST`, …) are listed in the [Dockerfile](Dockerfile).

## Build
Requires `devgeniem/ubuntu-docker-openresty-pagespeed` ([build the stack](https://github.com/devgeniem/docker-base#build)).
```bash
docker buildx build --platform linux/amd64 -t devgeniem/ubuntu-docker-wordpress .
```
