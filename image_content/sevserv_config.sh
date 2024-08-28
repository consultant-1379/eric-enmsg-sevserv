#!/bin/bash

# Sev Serv postinstall content
DIRNAME="/ericsson/tor/data/apps/siteenergyvisualization"

if [[ ! -d "$DIRNAME" ]]
then
    mkdir $DIRNAME
    chown jboss_user:jboss $DIRNAME
    chmod 755 $DIRNAME
fi

