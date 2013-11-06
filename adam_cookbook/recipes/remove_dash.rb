# See https://github.com/ddollar/foreman/issues/384
execute 'echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash -f noninteractive'
