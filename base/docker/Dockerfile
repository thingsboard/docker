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

FROM debian:${debian.codename}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install -y --no-install-recommends procps \
    && apt-get autoremove --purge --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup --system ${pkg.user} \
            --gid=799 \
    && adduser --quiet \
            --system \
            --uid=799 \
            --ingroup ${pkg.user} \
            --quiet \
            --disabled-login \
            --disabled-password \
            -gecos "Thingsboard application" \
            ${pkg.user} \
    && rm -rf /var/log/* \
    && chmod -R g+rwX /var/log \
    && mkdir -p /home/${pkg.user} \
    && chown ${pkg.user}:${pkg.user} /home/${pkg.user} \
    && chmod -R g+rwX /home/${pkg.user} \
    && ls -lah /home/${pkg.user}

ENV HOME=/home/${pkg.user}
