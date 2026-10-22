#
# Copyright © 2016-2026 The Thingsboard Authors
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

FROM ${docker.repo}/base:${debian.codename}

# Default to UTF-8 file.encoding
ENV LANG=C.UTF-8
ENV JAVA_HOME=/docker-java-home
ENV JAVA_VERSION=17.0.20.1
# https://packages.debian.org/bookworm/openjdk-17-jdk-headless
ENV JAVA_DEBIAN_VERSION=17.0.20.1+1-1~deb12u1

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    && { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home \
    && ln -svT "/usr/lib/jvm/java-17-openjdk-$(dpkg --print-architecture)" /docker-java-home \
    && mkdir -p /usr/share/man/man1 \
    && set -ex \
    && apt-cache madison openjdk-17-jdk-headless \
    && apt-get install -y --no-install-recommends \
    openjdk-17-jdk-headless="$JAVA_DEBIAN_VERSION" \
    && apt-get autoremove --purge --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
# expire resolved DNS in 60 sec
    && echo 'networkaddress.cache.ttl=60' >> /etc/java-17-openjdk/security/java.security \
    && tail /etc/java-17-openjdk/security/java.security \
# verify that "docker-java-home" returns what we expect
    && [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ] \
    && pwd \
    && ls -lah ~ \
# basic smoke test
    && fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; [ "$fileEncoding" = 'UTF-8' ] \
    && rm -rf ~/.java \
	&& javac -version \
	&& java -version

# FIXME: remove once JAVA_DEBIAN_VERSION ships tzdata 2026e; until then tzdb.dat is rebuilt from the jdk-17.0.21+9 sources
RUN set -ex \
    && installed=$(echo 'System.out.println(java.time.zone.ZoneRulesProvider.getVersions("UTC").lastKey())' | jshell -s -) \
    && [ -n "$installed" ] \
    && if [ ! "$installed" \< 2026e ]; then echo "JDK already ships tzdata $installed, remove this step"; exit 1; fi \
    && src=https://raw.githubusercontent.com/openjdk/jdk17u/e8adc958475b92b9f251145c6ce20532be16d806 \
    && zones="africa antarctica asia australasia europe northamerica southamerica backward etcetera gmt jdk11_backward" \
    && work=$(mktemp -d) && tools=$work/build/tools/tzdb && mkdir -p $tools $work/tzdata $work/classes \
    && apt-get update && dpkg --get-selections | awk '{print $1}' > $work/packages \
    && apt-get install -y --no-install-recommends curl \
    && for f in TzdbZoneRulesCompiler TzdbZoneRulesProvider; do curl -fsSL -o $tools/$f.java $src/make/jdk/src/classes/build/tools/tzdb/$f.java || exit 1; done \
    && for f in ZoneRules ZoneOffsetTransition ZoneOffsetTransitionRule Ser; do curl -fsSL -o $tools/$f.java $src/src/java.base/share/classes/java/time/zone/$f.java || exit 1; done \
    && sed -i 's/^package java.time.zone;/package build.tools.tzdb;/' $tools/ZoneRules.java $tools/ZoneOffsetTransition.java $tools/ZoneOffsetTransitionRule.java $tools/Ser.java \
    && for f in VERSION $zones; do curl -fsSL -o $work/tzdata/$f $src/make/data/tzdata/$f || exit 1; done \
    && grep -x tzdata2026e $work/tzdata/VERSION \
    && javac -nowarn -d $work/classes $tools/*.java \
    && java -cp $work/classes build.tools.tzdb.TzdbZoneRulesCompiler -srcdir $work/tzdata -dstfile $JAVA_HOME/lib/tzdb.dat $zones \
    && echo "a02e3a23d67255782b11ab81070902235ab564080f0f65ffe2a989cdaa86fe89  $JAVA_HOME/lib/tzdb.dat" | sha256sum -c \
    && apt-get purge -y --auto-remove $(dpkg --get-selections | awk '{print $1}' | grep -vxFf $work/packages) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* $work ~/.java
