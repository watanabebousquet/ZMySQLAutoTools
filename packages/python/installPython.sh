#!/bin/bash
#attention ,please use root user to execute this scripts. 

#1.install python-about packages

sudo yum -y install gcc gcc-c++ libffi libyaml-devel libffi-devel zlib zlib-devel openssl openssl-devel libyaml sqlite-devel libxml2 libxslt-devel libxml2-devel

#2.install python 

pythondir=`dirname $0`
cd $pythondir
tar -xvf python-3.6.2.tar.xz -C /tmp/
cd /tmp/Python-3.6.2/
./configure --prefix=/usr/local/python-3.6.2/
make -j 2
make install
cd /usr/local/
ln -s /usr/local/python-3.6.2  python
echo 'export PATH=/usr/local/python/bin/:$PATH' >> /etc/profile

source /etc/profile
export PATH


