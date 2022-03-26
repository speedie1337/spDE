#!/bin/sh
#            ____  _____ #
#  ___ _ __ |  _ \| ____|#
# / __| '_ \| | | |  _|  #
# \__ \ |_) | |_| | |___ #
# |___/ .__/|____/|_____|#
#     |_|                #
# spDE // installation script bu speedie
# Licensed under MIT.

echo "Detecting shell" && echo "Found $SHELL" && echo "#!$SHELL" > install-spde.sh
cat install-base.sh >> install-spde.sh && echo "Added base"
chmod +x install-spde.sh && echo "Changed permission of script"
./install-spde.sh
