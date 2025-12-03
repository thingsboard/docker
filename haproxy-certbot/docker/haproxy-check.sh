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


cfg_file=$1

if [ -z "$1" ]
  then
  	cfg_file="/config/haproxy.cfg"
    echo "No argument supplied, using" ${cfg_file}
    echo "To use config from host fs try \"(docker exec -i container haproxy-check -) < path_to_your_config\""
fi

/usr/local/sbin/haproxy -c -V -f ${cfg_file}
