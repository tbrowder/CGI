#!/bin/bash

# this script is to be executed in the TOP-LEVEL DIR OF THE REPO, i.e.,

#   ./dedi2/install.sh

# put cgi files in proper place on dedi2
HOST=dedi2
D=$HOST:/myperl6/bin
scp ./$HOST/*.cgi $D

# also need current GGI modules
D2=$HOST:/myperl6/lib
scp ./lib/CGI.pm6 $D2

D3=$HOST:/myperl6/lib/CGI
scp ./lib/CGI/Vars.pm6 $D3
