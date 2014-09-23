FROM ubuntu:14.04

MAINTAINER Mojo Lingo LLC <ops@mojolingo.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y libpcre3 libpcre3-dev libxml2 libxslt1-dev ruby2.1 ruby2.1-dev build-essential
RUN gem install bundler

ADD . /app

WORKDIR /app

RUN bundle install --deployment --path /var/bundle

CMD bin/run
