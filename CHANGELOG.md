# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [1.7.0] - 2021-08-12
### Changed
- Updated repo to use edge2 tag from devgeniem/ubuntu-docker-openresty-pagespeed. This might be a breaking change

### Added
- Installed Imagemagick for php
- Skip cache reason to header

### Fixed
- Fixed blacklist and whitelist modes

### Added
- fastcgi_intercept_errors configurable from env FASTCGI_INTERCEPT_ERRORS, default on

### Fixed
- Updated map_hash_bucket_size value to 128 as previous value was out of scope.

## [1.6.2] - 2021-02-25
### Added

-  added $cookie_nocache variable to cache bypass to enable cache bypass control via cookie

## [1.6.1] - 2021-02-25
### Fixed
- Redis envs rendered again to make redis work

## [1.6] - 2021-01-27
### Removed
- old php versions

### Added
- more envs for configuring  
- php process manager configurable from envs
- ignore cache key attributes
- renamed envs for clarity
- PHP_DISABLE_FUNCTIONS env

## [1.5.2] - 2020-08-10

### Added
- socklog to log syslog and cronlog for better debugging
- added wordpress_sec cookie to skip fullpage cache
- more security headers
- updated socklog to latest version

### Fixed
- headers where added in many places which made them not working correctly. Now headers are added in one place. For any headeres please use XXX_headers.conf files in 
- php cli errorlog forwarded to /proc/1/fd/2 to make it work

## [1.5.1] - 2020-xx-xx

### Fixed
- Updated error page external libraries to new versions

## [1.5.0] - 2020-03-02

### Changed
- `php74` tag now uses the updated edge base image with newer Ubuntu, Nginx, Pagespeed and S6 versions

## [1.4.2] - 2020-14-02

### Added
- changed pm.max_spare_servers 3 -> 5 for php73 and php74

## [1.4.1] - 2019-11-13

### Added
- possibility to add nginx configuration to @index location

## [1.4.0] - 2019-11-11

### Added
- Force /robots.txt to always serve "disallow all" response when on development domains (gpilvi.com or geniem.io).

## [1.3.0] - 2019-10-30

### Added
- Prevent loading of .dust files outside the specifically defined /partials/public directory.

## [1.2.10] - 2019-09-18

### Added
- A possibility to set plain text basic auth password via BASIC_AUTH_PASSWORD env.

## [1.2.9] - 2019-09-17

### Changed
- Fixed another php7.0 build error

## [1.2.8] - 2019-09-16

### Changed
- Fixed php7.2 build error

## [1.2.7] - 2019-09-16

### Changed
- Fixed php7.0 build error

## [1.2.6] - 2019-08-22

### Changed
- Changed php error log path to /dev/stderr for php 72 and 73

## [1.2.5] - 2019-08-21

### Added 
- set cache header to be shown always, including 404

## [1.2.4] - 2019-08-14

### Added 
- #Load custom environment variables -> include env.conf;

## [1.2.3] - 2019-06-03

### changed
- fixed cache var default values for php71 and php72

## [1.2.2] - 2019-04-16

### Added
- option to enable fast cgi caching for given query parameters in CACHE_QUERYVARS env
- A possibility to define accepted query parameters for cache in environment variables.
- A possibility to define customizations for the cache key by project, e.g. by cookies and/or location.

## [1.2.3] - 2018-12-10

### Changed
- srcache log parameter changed to upstream_cache_status since we use fastcgi cache now

### Added
- hostname to logs to see what domain the request is affecting

## [1.2.2] - 2018-10-22

### Added
- added a possibility to set plain text basic auth password via BASIC_AUTH_PASSWORD env.

## [1.2.1] - 2018-10-18

### Added
- added tags latest to php7.0 and php7.1

### Changed
- changed php 7.2 tag from beta to php72

## [1.2.1] - 2018-06-04
### Changed
- image now reads config from project's nginx/environments/x/root to / block
- image now reads skipcache rules from nginx/skipcache folder skip_cache.conf is deprecated and will be removed soon. 

## [1.2.0] - 2018-04-30
### Added
- PHP 7.0 option

## [1.1.1] - 2018-04-18
### Changed
- 7.1 image to point to docker hub instead of private repository

### Removed
- php 7.2 and 7.1 package that adds apache2 that is not needed

## [1.1.0] - 2018-01-18
### Added
- GOOGLE_CLOUD_STORAGE_BUCKET_NAME env variable for nginx

## [1.0.0] - 2018-01-09
### Added
- This changelog

### Changed
- New FROM path for base image in Dockerfile `devgeniem/ubuntu-docker-openresty-pagespeed`
