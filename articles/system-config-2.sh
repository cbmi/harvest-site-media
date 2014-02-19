#!/bin/bash
#
# The first half of a bash script for setting up a python development 
# ready, Harvest-friendly system environment on CentOS 6 boxes. Intended 
# for folks without much sysadmin or python experience, without interest 
# in dealing with puppet or another config tool, who just want to get moving.
#
# Two caveats:
# 1. These steps represent one way of doing things, not the way. This guide 
# intentionally eschews justification in deference to brevity.
# 2. These steps are intended for CentOS 6 (64 bit arch) because that's the OS 
# in which I do development. With minor modification, they would probably work 
# on Redhat. With major modification, but similar intent, they would probably 
# work on most Linux distros. Again in deference to brevity, I didn't try for 
# universality.
#
# This part of the script needs to be run by a user with sudo privileges.
#
# Please reach out to us if you're having trouble:
# http://harvest.research.chop.edu/contact/
#
# Written by Aaron Browne brownea@email.chop.edu 
# Center for Biomedical Informatics, Children's Hospital of Philadelphia
# Last update on 2/14/2014
#
echo
echo 'Create '/home/devuser/local' and configure PATH'
echo
# I'll break caveat 1 here to say that I chose '/home/devuser/local' as the 
# install prefix so that if a sysadmin was able to run the above portion, 
# the rest of the script can be run without root privileges of any kind 
# (unlike installing to '/opt' or '/usr/local'). It is also extremely unlikely 
# to conflict with other users or applications on your system (as installing 
# to '/usr/local' might).
echo
set -x
mkdir /home/devuser/local
echo 'export PATH=/home/devuser/local/bin:${PATH}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/home/devuser/local/lib:${LD_LIBRARY_PATH}' >> ~/.bashrc
set +x
# Explicitly echo this command to avoid polluting the output with all the 
# commands in the ~/.bashrc file.
echo 'source ~/.bashrc'
source ~/.bashrc
echo
echo 'Compile and install python 2.7'
echo
# This script was tested and I have been developing in python 2.7.3, but 
# later 2.7.x versions are available (2.7.6 is the latest as of writing). It's 
# up to you if you want to find the latest 2.7.x and use that instead, it most 
# likely won't make a difference.
echo
set -x
mkdir /home/devuser/downloads
cd /home/devuser/downloads
wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
tar -xzf Python-2.7.3.tgz
cd Python-2.7.3
/bin/bash configure --enable-shared --prefix=/home/devuser/local
make
make install
set +x
echo
# At this point, executing 'which python' should return 
# '/home/devuser/local/bin/python'. If it doesn't, try reloading your shell 
# session.
echo
echo 'Install pip and important python packages'
echo
set -x
cd /home/devuser/downloads 
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
pip install distribute virtualenv uwsgi supervisor
set +x
echo
echo 'Install node.js, npm, and important node packages'
echo
set -x
wget http://nodejs.org/dist/node-latest.tar.gz 
tar -xzf node-latest.tar.gz
cd node-v*
./configure --prefix=/home/devuser/local && make install
cd /home/devuser/downloads
set +x
# As of writing, the certificate on npmjs.org fails, but only because it is 
# registered to nodejs.org
set -x
wget --no-check-certificate https://npmjs.org/install.sh -O install-npm.sh
/bin/bash install-npm.sh
npm install -g grunt-cli coffee-script
set +x
echo
echo 'Create a home for your webapps'
echo
set -x
mkdir /home/devuser/webapps
set +x
echo
echo "Now, you're ready to download Harvest: http://harvest.research.chop.edu/download/"
echo
