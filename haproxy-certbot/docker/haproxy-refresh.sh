#!/bin/sh
#
# Copyright © 2016-2025 The Thingsboard Authors
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


HA_PROXY_DIR=/usr/local/etc/haproxy
LE_DIR=/etc/letsencrypt/live
DOMAINS=$(ls ${LE_DIR})

# update certs for HA Proxy
for DOMAIN in ${DOMAINS}
do
 if [ -d "$LE_DIR/$DOMAIN" ]; then
  cat ${LE_DIR}/${DOMAIN}/fullchain.pem ${LE_DIR}/${DOMAIN}/privkey.pem > ${HA_PROXY_DIR}/certs.d/${DOMAIN}.pem
 fi
done

# restart haproxy
exec /usr/bin/haproxy-restart
