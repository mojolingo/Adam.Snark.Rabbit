#!/bin/bash

echo "vagrant ALL=(ALL:ALL) ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
