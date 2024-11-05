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

FROM k8ssandra/medusa:0.22.2

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install Java and dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jre wget gettext gnupg && \
    rm -rf /var/lib/apt/lists/*

# Add Cassandra repository and install cassandra-tools
RUN wget -q -O - https://downloads.apache.org/cassandra/KEYS | apt-key add - && \
    echo "deb https://debian.cassandra.apache.org 41x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    apt-get update && \
    apt-get install -y cassandra-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/cassandra/logs && \
    chown cassandra:cassandra /usr/share/cassandra/logs && \
    chmod -R g+rwX /usr/share/cassandra/logs && \
    echo 'done'

ENV CASSANDRA_HOME=/usr/share/cassandra
ENV PATH=$PATH:$CASSANDRA_HOME/bin

USER cassandra
