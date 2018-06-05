# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
