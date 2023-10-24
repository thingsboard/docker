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

# haproxy with certbot
FROM haproxy:${haproxy.version}-alpine${alpine.version}

RUN set -eux \
  && haproxy -v \
  && apk add --no-cache --update \
    ca-certificates \
    supervisor \
    libnl3-cli \
    net-tools \
    iproute2 \
    certbot \
    openssl \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /var/log/supervisor \
  && mkdir -p /usr/local/etc/haproxy/certs.d \
  && mkdir -p /usr/local/etc/letsencrypt

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup Certbot

COPY certbot.cron /etc/cron.d/certbot
COPY cli.ini /usr/local/etc/letsencrypt/cli.ini
COPY haproxy-refresh.sh /usr/bin/haproxy-refresh
COPY haproxy-restart.sh /usr/bin/haproxy-restart
COPY haproxy-check.sh /usr/bin/haproxy-check
COPY certbot-certonly.sh /usr/bin/certbot-certonly
COPY certbot-renew.sh /usr/bin/certbot-renew
RUN chmod +x /usr/bin/haproxy-refresh /usr/bin/haproxy-restart /usr/bin/haproxy-check /usr/bin/certbot-certonly /usr/bin/certbot-renew \
    && crontab /etc/cron.d/certbot

# Add startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443
VOLUME ["/config/", "/etc/letsencrypt/", "/usr/local/etc/haproxy/certs.d/"]

# Override entypoint from source image
ENTRYPOINT []
# Start
CMD ["/start.sh"]
