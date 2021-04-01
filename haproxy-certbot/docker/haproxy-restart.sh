#!/bin/sh
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


nl-qdisc-add --dev=lo --parent=1:4 --id=40: --update plug --buffer
/usr/local/sbin/haproxy -f /config/haproxy.cfg -D -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)
nl-qdisc-add --dev=lo --parent=1:4 --id=40: --update plug --release-indefinite
