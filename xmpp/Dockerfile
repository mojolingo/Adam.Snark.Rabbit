FROM ubuntu:14.04

MAINTAINER Mojo Lingo LLC <ops@mojolingo.com>

# System update
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget libyaml-0-2 libexpat1

# erlang
RUN wget -q -O /tmp/erlang-solutions_1.0_all.deb http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i /tmp/erlang-solutions_1.0_all.deb
RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install erlang-nox

# ejabberd
RUN wget -q -O /tmp/ejabberd-installer.run "http://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/14.07/ejabberd-14.07-linux-x86_64-installer.run"
RUN chmod +x /tmp/ejabberd-installer.run
RUN /tmp/ejabberd-installer.run --mode unattended --prefix /opt/ejabberd --adminpw ejabberd

# config
ADD ./ejabberd.yml.erb /opt/ejabberd/conf/ejabberd.yml.erb
ADD ./ejabberdctl.cfg /opt/ejabberd/conf/ejabberdctl.cfg
RUN sed -i "s/ejabberd.cfg/ejabberd.yml/" /opt/ejabberd/bin/ejabberdctl

# extauth script
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y ruby2.1
ADD ./ejabberd_auth.rb /opt/ejabberd/conf/ejabberd_auth.rb
RUN chmod +x /opt/ejabberd/conf/ejabberd_auth.rb

# wrapper for setting config on disk from environment
# allows setting things like XMPP domain at runtime
ADD ./run /opt/ejabberd/bin/run

EXPOSE 5222 5269 5280
CMD ["/opt/ejabberd/bin/run", "live"]
