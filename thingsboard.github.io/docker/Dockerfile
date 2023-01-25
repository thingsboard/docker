# FROM debian:10.13
FROM ruby:3.1

RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get autoremove \
    && apt-get install -y --no-install-recommends \
       procps software-properties-common make g++\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem install github-pages jekyll

WORKDIR /thingsboard.github.io/

EXPOSE 4000

CMD bundle install && bundle add webrick && ./restart.sh
