#!/bin/bash

apache2ctl stop

# put files in proper place
#cp ./travis/*.cgi /var/www/html
cp ./travis/*.cgi /usr/lib/cgi-bin
#cp ./travis/*.conf /etc/apache2/conf-available

a2disconf my-cgi
a2enconf my-cgi

# also need mod_cgid
a2enmod -q cgid
apache2ctl start
