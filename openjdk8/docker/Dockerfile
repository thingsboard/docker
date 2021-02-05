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

FROM thingsboard/base

RUN echo 'deb http://ftp.us.debian.org/debian sid main' | tee --append /etc/apt/sources.list.d/debian.list > /dev/null

RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home
# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home
ENV JAVA_VERSION 8u275
ENV JAVA_DEBIAN_VERSION 8u275-b01-1
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    \
# verify that "docker-java-home" returns what we expect
    [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
    \
# basic smoke test
	javac -version; \
	java -version
