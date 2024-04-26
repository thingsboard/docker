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

FROM ruby:2.7.7

RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get autoremove --purge --yes \
    && apt-get install -y --no-install-recommends \
        software-properties-common make g++ graphicsmagick-imagemagick-compat\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler -v 2.0.1 \
    && gem install 'jekyll:~>3.9.2' \
    && gem install nokogiri -v 1.15.5 \
    && gem install faraday-net_http -v 3.0.2 \
    && gem install faraday -v 2.8.1 \
    && gem install 'github-pages'

WORKDIR /website/

EXPOSE 4000

CMD bundle install && ./restart.sh
