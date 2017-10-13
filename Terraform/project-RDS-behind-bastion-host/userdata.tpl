#!/bin/bash
# Update all packages
yum -y update
# Install mysql client 
yum -y install mysql
# Install telnet
yum -y install telnet