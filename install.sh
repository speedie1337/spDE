#!/bin/sh

echo "Detecting shell" && echo "Found $SHELL" && echo "#!$SHELL" > install-spde.sh

cat install-base.sh >> install-spde.sh && echo "Added base"

chmod +x install-spde.sh && echo "Changed permission of script"

echo "Running script" && ./install-spde.sh
