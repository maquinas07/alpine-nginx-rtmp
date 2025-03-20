ARG NGINX_VERSION=1.27.4
ARG NGINX_RTMP_VERSION=1.2.2

FROM alpine:3.21 AS build
ARG NGINX_VERSION
ARG NGINX_RTMP_VERSION

RUN \
  build_pkgs="build-base linux-headers openssl-dev pcre-dev wget zlib-dev patch" && \
  apk --no-cache add ${build_pkgs} ${runtime_pkgs} && \
  cd /tmp && \
  wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  wget https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz && \
  tar xzf nginx-${NGINX_VERSION}.tar.gz && \
  tar xzf v${NGINX_RTMP_VERSION}.tar.gz && \
  cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --add-module=../nginx-rtmp-module-${NGINX_RTMP_VERSION} \
    --with-http_ssl_module && \
  make && \
  make install && \
  rm -rf /tmp/* && \
  apk del ${build_pkgs} && \
  rm -rf /var/cache/apk/*

FROM alpine:3.21

LABEL MAINTAINER="Elias Menon <eliasmenon@gmail.com>"

COPY --from=build /usr/sbin/nginx /usr/sbin/nginx
COPY --from=build /etc/nginx /etc/nginx
COPY nginx.conf /etc/nginx/nginx.conf

RUN \
  apk add --no-cache ca-certificates openssl pcre zlib tzdata git && \
  mkdir /var/log/nginx && \
  ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 1935

CMD ["nginx"]
