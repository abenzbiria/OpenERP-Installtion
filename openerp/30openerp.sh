#! /bin/bash
#PARAMS
log_src='[30openerp.sh]'
Log="/root/install-openerp.log"
DATADIR="/mnt/data"
#TODO
COMP="COMP"
#LPDIR="http://bazaar.launchpad.net/~openerp/openobject-addons/7.0/"
# LPDIR="sftp://bzr@42.120.43.36:37155/lp/7.0/web/"

echo $log_src[`date +%F.%H:%M:%S`]' Starting OpenERP Installation'>>$Log
#create dir
[ -f $DATADIR ] || mkdir $DATADIR
[ -f $DATADIR/openerp ] || mkdir $DATADIR/openerp
ln -s $DATADIR/openerp /opt/

useradd -U -Gsudo -P -b /mnt/data/ openerp
#usermod -a -Gsduo username
chown openerp:openerp -R /mnt/data/openerp

#branch Stable
ERPDIR=$DATADIR/openerp/
[ -f $ERPDIR/stable ] || mkdir $ERPDIR/stable
[ -f $ERPDIR/stable/addons ] || mkdir $ERPDIR/stable/extra_addons
[ -f $ERPDIR/stable/addons ] || mkdir $ERPDIR/stable/batch
bzr branch lp:openerp-web/7.0 $ERPDIR/stable/web
bzr branch lp:openobject-server/7.0 $ERPDIR/stable/server
bzr branch lp:openobject-addons/7.0 $ERPDIR/stable/addons
# Stable bzr
cd /opt/openerp/stable
bzr init
mv addons/.bzr addons/bzr.back
mv server/.bzr server/bzr.back
mv web/.bzr web/bzr.back
bzr add
bzr commit -m "init version"
bzr push --create-prefix --remember sftp://bzr@server:37155/servers/$COMP/70/stable
echo $log_src[`date +%F.%H:%M:%S`]' Create stable bzr branch in Robin'>>$Log


# install dependac
sudo apt-get install graphviz ghostscript postgresql-client \
python-dateutil python-feedparser python-matplotlib \
python-ldap python-libxslt1 python-lxml python-mako \
python-openid python-psycopg2 python-pybabel python-pychart \
python-pydot python-pyparsing python-reportlab python-simplejson \
python-tz python-vatnumber python-vobject python-webdav \
python-werkzeug python-xlwt python-yaml python-imaging

#extra
sudo apt-get install gcc python-dev mc bzr python-setuptools python-babel \
python-feedparser python-reportlab-accel python-zsi python-openssl \
python-egenix-mxdatetime python-jinja2 python-unittest2 python-mock \
python-docutils lptools make python-psutil python-paramiko poppler-utils \
python-pdftools

#gdata
wget http://gdata-python-client.googlecode.com/files/gdata-2.0.17.tar.gz 
tar zxvf gdata-2.0.17.tar.gz 
cd gdata-2.0.17/
sudo python setup.py install

#wk
sudo -u postgres createuser -s openerp

#CP local.conf
cp /tmp/source/local.conf $ERPDIR/trunk/

#CP init.file
cp /tmp/source/openerp-server_release /etc/init.d/openerp-server_trunk


#bzr commit -m "init version"
bzr push --create-prefix --remember sftp://server/servers/$COMP/trunk
echo $log_src[`date +%F.%H:%M:%S`]' Create Trunk bzr branch in Robin'>>$Log

#push back to server
echo $log_src[`date +%F.%H:%M:%S`]' End OpenERP Installation'>>$Log
