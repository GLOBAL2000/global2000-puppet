#!/bin/bash

if ping -c1 puppet.g2 &> /dev/null; then
    sleep 5;
    /usr/bin/unattended-upgrade
    sleep 5;
    env -i HOME="" PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" /usr/sbin/puppetd -t;
else
    exit 0;
fi
