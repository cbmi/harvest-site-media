#!/bin/bash
#
# The second half of a bash script for setting up a python development 
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
# This part of the script needs to be run by the user who will be doing 
# Harvest development.
#
# Please reach out to us if you're having trouble:
# http://harvest.research.chop.edu/contact/
#
# Written by Aaron Browne brownea@email.chop.edu 
# Center for Biomedical Informatics, Children's Hospital of Philadelphia
# Last update on 2/14/2014
#
echo
echo 'Make a user for shared app development'
echo
set -x
sudo useradd -m devuser
sudo chmod g+rwxs /home/devuser
set +x
echo
echo 'Add your own user to the devuser group'
echo
set -x
sudo usermod -a -G devuser `whoami`
set +x
echo
echo 'Add supplementary yum repo'
echo
set -x
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
set +x
echo
echo 'Install system packages and then upgrade everything'
echo
# This list includes packages for a production deployment. Some needs may be 
# differ depending on your choice of database and web server.
set -x
sudo yum install httpd-devel openssl-devel ncurses-devel rpm-devel apr-util-devel apr-devel glibc-devel memcached readline-devel bzip2 bzip2-devel bzip2-libs libpng-devel openldap-devel freetype fontconfig freetype-devel lapack-devel blas-devel libgfortran gcc-gfortran gcc 'gcc-c++' postgresql-devel zlib-devel libcurl-devel expat-devel gettext-devel nginx sqlite-devel vim python-devel gmp-devel man
sudo yum groupinstall 'Development tools'
sudo yum upgrade
set +x
echo
echo 'Dropping you into a subshell with devuser group membership,'
echo 'you can run the second half of the script now'
echo
newgrp devuser
