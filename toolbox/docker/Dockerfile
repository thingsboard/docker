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

FROM alpine:${alpine.version}
RUN apk add --no-cache postgresql-client
RUN apk add --no-cache py3-pip
RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN pip install cqlsh --break-system-packages
WORKDIR /scripts
COPY *.sh /scripts/
