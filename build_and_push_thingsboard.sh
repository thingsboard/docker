#!/bin/sh
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

# Rebuilds only the images ThingsBoard runs on: base (trixie and bookworm), openjdk17, openjdk25 and node

set -e # exit on any error

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD | sed 's/[\/]/-/g')
COMMIT_ID=$(git rev-parse --short HEAD)
VERSION_TAG="${BRANCH_NAME}-${COMMIT_ID}"

echo "$(date) Building ThingsBoard images from $VERSION_TAG ..."
set -x

docker buildx prune -af
mvn clean install -P push-docker-amd-arm-images -pl base -Ddebian.codename=trixie-slim
mvn clean install -P push-docker-amd-arm-images -pl base
mvn clean install -P push-docker-amd-arm-images -pl openjdk17,openjdk25,node

set +x
echo "$(date) Done. ${VERSION_TAG}"
