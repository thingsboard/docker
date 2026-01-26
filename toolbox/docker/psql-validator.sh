#!/bin/bash
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


retryCount="${RETRY_COUNT:-5}"
secondsBetweenRetry="${SECONDS_BETWEEN_RETRY:-5}"
#Mast have this env
#PGHOST
#PGDATABASE
#PGUSER
#PGPASSWORD
queryForTable="${QUERY_TO_VALIDATE_TABLE:-"SELECT (1 / (SELECT count(*) FROM information_schema.tables where table_schema = 'public'))::int::boolean;"}"
queryForData="${QUERY_TO_VALIDATE_DATA:-"SELECT (1 / (Select count(*) from queue))::int::boolean;"}"


function validatePostgres() {
    runFunctionWithRetry pg_isready -q
    runFunctionWithRetry psql -A --csv -c "$queryForTable" -q
    runFunctionWithRetry psql -A --csv -c "$queryForData" -q
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

validatePostgres