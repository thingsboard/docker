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

FROM thingsboard/base:${debian.codename}

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV JAVA_HOME /docker-java-home
ENV JAVA_VERSION 17.0.8
ENV JAVA_DEBIAN_VERSION 17.0.8+7-1~deb12u1

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home \
    && ln -svT "/usr/lib/jvm/java-17-openjdk-$(dpkg --print-architecture)" /docker-java-home \
    && mkdir -p /usr/share/man/man1 \
    && set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk="$JAVA_DEBIAN_VERSION" \
    ; \
    rm -rf /var/lib/apt/lists/*; \
# expire resolved DNS in 60 sec
    echo 'networkaddress.cache.ttl=60' >> /etc/java-17-openjdk/security/java.security \
    \
# verify that "docker-java-home" returns what we expect
    [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
    \
# basic smoke test
    fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ]; rm -rf ~/.java; \
	javac -version; \
	java -version
