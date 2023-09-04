# Under construction
README was deleted due to legacy reasons.

New README will come later.

## Building
```bash
# start buildx
docker run --privileged --rm tonistiigi/binfmt --install all # optional
docker buildx create --name mybuilder --use --bootstrap

# clone image repositories
git clone --depth 1 -b edge git@github.com:devgeniem/docker-base.git docker-base_edge
git clone --depth 1 -b edge-arm git@github.com:devgeniem/docker-base.git docker-base_edge-arm
git clone --depth 1 -b edge2 git@github.com:devgeniem/ubuntu-docker-openresty-pagespeed.git ubuntu-docker-openresty-pagespeed_edge2
git clone --depth 1 -b php81-stable-sok git@github.com:devgeniem/ubuntu-docker-wordpress.git ubuntu-docker-wordpress_php81-stable-sok

# build base image
docker buildx build --platform linux/amd64,linux/amd64/v2,linux/amd64/v3 -t devgeniem/base:edge docker-base_edge/ubuntu
docker buildx build --platform linux/arm64,linux/ppc64le,linux/s390x,linux/arm/v7 -t devgeniem/base:edge docker-base_edge-arm/ubuntu

# build openresty
docker buildx build --platform linux/amd64,linux/amd64/v2,linux/amd64/v3,linux/arm64,linux/ppc64le,linux/s390x,linux/arm/v7 -t devgeniem/ubuntu-docker-openresty-pagespeed:edge2 ubuntu-docker-openresty-pagespeed_edge2

# build php, current repository image. add --push flash to push to dockerhub afterwards, or use a single platform and --load flag to test everything works first
docker buildx build --platform linux/amd64,linux/amd64/v2,linux/amd64/v3,linux/arm64,linux/ppc64le,linux/s390x,linux/arm/v7 -t devgeniem/ubuntu-docker-wordpress:php81-stable-sok ubuntu-docker-wordpress_php81-stable-sok/ubuntu-8.1
```
