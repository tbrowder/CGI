#!/bin/bash

apache2ctl stop

# put files in proper place
cp ./travis/*.cgi /var/www/html
cp ./travis/*.conf /etc/apache2/conf-available

a2enconf my-cgi
apache2ctl start

