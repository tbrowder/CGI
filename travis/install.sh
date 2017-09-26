#!/bin/bash

# make sure we know where perl6 is
P=/usr/bin/perl6
if [[ ! -f $P ]] ; then
    echo "perl6 is NOT at '$P'";
    exit 1
else
    echo "perl6 IS at '$P'";
fi

cp ./travis/*.cgi /var/www/html

apachectl stop
apachectl start

