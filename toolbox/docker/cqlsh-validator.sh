#!/bin/bash

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


retryCount="${RETRY_COUNT:-5}"
secondsBetweenRetry="${SECONDS_BETWEEN_RETRY:-5}"
cassandraHost="${CASSANDRA_HOST:-127.0.0.1}"
cassandraKeyspace="${CASSANDRA_KAYSPACE:-thingsboard}"
cassandraUser="${CASSANDRA_USER:-cassandra}"
cassandraPassword="${CASSANDRA_PASSWORD:-cassandra}"
queryToValidate="${QUERY_TO_VALIDATE_TABLE:-"DESCRIBE TABLES"}"


function validateCassandra() {
    runFunctionWithRetry cqlsh $cassandraHost 9042 -u $cassandraUser -p $cassandraPassword -k $cassandraKeyspace --execute="$queryToValidate"

}

function runFunctionWithRetry() {
  local retryCounter=0;
  until [ $retryCounter == $retryCount ]; do
      if "$@"; then
              echo "Command [$*] succeed";
              break ;
          else
              echo "Command [$*] failed"
              retryCounter=$((retryCounter+1));
              sleep $secondsBetweenRetry;
          fi
  done

}

validateCassandra