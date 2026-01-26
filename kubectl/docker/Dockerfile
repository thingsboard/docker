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

FROM bitnamilegacy/kubectl:1.33-debian-12

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gettext && \
# git removed due to the latest vulnerabilities
    apt-get purge git git-man -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

USER 1001

RUN kubectl version --client && \
    which envsubst
