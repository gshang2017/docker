#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ "$NOVNC_LANGUAGE" = "zh_Hans" ]; then
  cp -rf /opt/noVNC/index.html.zh /opt/noVNC/index.html
else
  cp -rf /opt/noVNC/index.html.en /opt/noVNC/index.html
fi
chmod 755 /opt/noVNC/index.html
