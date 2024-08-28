#!/bin/bash
_RSYNC=/usr/bin/rsync
#  Change this application list to the applications installed by your RPM
apps=(siteenergyvisualization)
for app in "${apps[@]}"
do
    # We assume your RPM is installing the files at /var/www/html/${app}/metadata/ during installation
    $_RSYNC -avz --chmod=g+rw --no-times --no-perms --no-group /var/www/html/${app}/metadata/* ericsson/tor/data/apps
    if [ $? -ne 0 ]
    then
        exit 1
    fi
    mkdir -p /ericsson/tor/data/apps/${app}/locales/en-us/
    $_RSYNC -avz --chmod=g+rw --no-times --no-perms --no-group /var/www/html/locales/en-us/${app}/app.json ericsson/tor/data/apps/${app}/locales/en-us/
    if [ $? -ne 0 ]
    then
        exit 1
    fi
done
