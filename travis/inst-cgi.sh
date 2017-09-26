#!/bin/bash

# put cgi files in proper place
D=/var/www/html
cp ./travis/*.cgi $D
chown www-data.www-data $D/*

