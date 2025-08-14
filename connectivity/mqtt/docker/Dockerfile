#
# Copyright © 2016-2024 The Thingsboard Authors
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

# Reference https://github.com/efrecon/docker-images/blob/master/mqtt-client/Dockerfile
#ARG ALPINE_VERSION=3.14.1
FROM alpine:${alpine.version}

ARG MOSQUITTO_VERSION=2.0.21
ARG PACKAGE_RELEASE=0
ARG BUILD_DATE=2025-08-14

# OCI Meta information
LABEL org.opencontainers.image.authors="Emmanuel Frecon <efrecon@gmail.com>"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.version=${MOSQUITTO_VERSION}
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/mqtt-client/Dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/mqtt-client/README.md"
LABEL org.opencontainers.image.licenses="BSD"
LABEL org.opencontainers.image.title="MQTT Client"
LABEL org.opencontainers.image.description="mosquitto clients for sending data and/or subscribing to topics"

VOLUME /opt/certs

RUN apk add --no-cache ca-certificates tini mosquitto-clients=${MOSQUITTO_VERSION}-r${PACKAGE_RELEASE} && \
    /etc/ca-certificates/update.d/certhash && \
    ln -s /usr/bin/mosquitto_pub /usr/local/bin/pub && \
    ln -s /usr/bin/mosquitto_sub /usr/local/bin/sub && \
    apk add --no-cache curl && \
    mkdir -p /home/nobody && \
    chown -R nobody:nobody /home/nobody

WORKDIR /home/nobody
ENV HOME=/home/nobody

USER nobody

ENTRYPOINT [ "/sbin/tini", "--" ]
