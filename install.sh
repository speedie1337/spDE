#!/bin/sh

echo "Detecting shell" && echo "Found $SHELL" && echo "#!$SHELL" > install-spde.sh

cat install-base.sh >> install-spde.sh && echo "Added base"

chmod +x install-spde.sh && echo "Changed permission of script"

doas ./install-spde.sh || sudo ./install-spde.sh || su - root -c "./install-spde.sh" || echo "Not installing." && echo 1
