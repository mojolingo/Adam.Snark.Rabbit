#!/bin/bash
#
#  Chef-Solo bootstrap script for a new Adam Snark Rabbit server

username=blangfeld
password=d2j29jd902kok2k

apt-get install curl -y
curl -L http://www.opscode.com/chef/install.sh | bash

mkdir /var/chef

wget --auth-no-challenge --http-user="$username" --http-password="$password" http://ci.mojolingo.com/job/Adam.Snark.Rabbit/lastBuild/artifact/build/standalone-databags.tgz
tar -xf standalone-databags.tgz --directory /var/chef

wget --auth-no-challenge --http-user="$username" --http-password="$password" http://ci.mojolingo.com/job/Adam.Snark.Rabbit/lastBuild/artifact/build/roles.tgz
tar -xf roles.tgz --directory /var/chef

wget --auth-no-challenge --http-user="$username" --http-password="$password" http://ci.mojolingo.com/job/Adam.Snark.Rabbit/lastBuild/artifact/build/cookbooks.tgz
tar -xf cookbooks.tgz --directory /var/chef

chef-solo -l debug -j dna.json

echo ""
echo "Success! Adam Snark Rabbit was installed!"
echo ""
