#
# Copyright © 2016-2020 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# haproxy2.2.11 with certbot
FROM alpine:3.12

ENV HAPROXY_MAJOR 2.2
ENV HAPROXY_VERSION 2.2.12

RUN set -x \
    \
    &&  apk add --no-cache --virtual .build-deps \
    ca-certificates \
    gcc \
    libc-dev \
    linux-headers \
    lua5.3-dev \
    make \
    openssl \
    openssl-dev \
    pcre2-dev \
    readline-dev \
    tar \
    zlib-dev \
    # install HAProxy
    && wget -O haproxy.tar.gz "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" \
    && mkdir -p /usr/src/haproxy \
    && tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1  \
    && rm haproxy.tar.gz \
    && make -C /usr/src/haproxy -j"$(nproc)" TARGET=linux-musl CPU=generic USE_PCRE2=1 USE_PCRE2_JIT=1 USE_REGPARM=1 USE_OPENSSL=1 \
                                USE_ZLIB=1 USE_TFO=1 USE_LINUX_TPROXY=1 USE_GETADDRINFO=1 \
                                USE_LUA=1 LUA_LIB=/usr/lib/lua5.3 LUA_INC=/usr/include/lua5.3 \
                                EXTRA_OBJS="contrib/prometheus-exporter/service-prometheus.o" \
                                all  \
    && make -C /usr/src/haproxy TARGET=linux2628 install-bin install-man  \
    && mkdir -p /usr/local/etc/haproxy \
    && cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
    && rm -rf /usr/src/haproxy  \
    && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .haproxy-rundeps $runDeps \
  && apk del .build-deps \
  && apk add --no-cache openssl zlib lua5.3-libs pcre2

# Install certbot, supervisor, libnl-utils, net-tools, iptables
RUN apk add --no-cache --update \
    supervisor \
    libnl3-cli \
    net-tools \
    iproute2 \
    certbot \
    openssl \
  && rm -rf /var/cache/apk/*

# Setup Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup Certbot
RUN mkdir -p /usr/local/etc/haproxy/certs.d
RUN mkdir -p /usr/local/etc/letsencrypt
COPY certbot.cron /etc/cron.d/certbot
COPY cli.ini /usr/local/etc/letsencrypt/cli.ini
COPY haproxy-refresh.sh /usr/bin/haproxy-refresh
COPY haproxy-restart.sh /usr/bin/haproxy-restart
COPY haproxy-check.sh /usr/bin/haproxy-check
COPY certbot-certonly.sh /usr/bin/certbot-certonly
COPY certbot-renew.sh /usr/bin/certbot-renew
RUN chmod +x /usr/bin/haproxy-refresh /usr/bin/haproxy-restart /usr/bin/haproxy-check /usr/bin/certbot-certonly /usr/bin/certbot-renew

# Setup cron job to renew certificate
RUN crontab /etc/cron.d/certbot

# Add startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443
VOLUME ["/config/", "/etc/letsencrypt/", "/usr/local/etc/haproxy/certs.d/"]

# Start
CMD ["/start.sh"]
