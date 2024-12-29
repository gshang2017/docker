#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

if [ ! -f /opt/base/etc/openbox/rc.xml.template.bak ] ; then
  cp -f /opt/base/etc/openbox/rc.xml.template /opt/base/etc/openbox/rc.xml.template.bak
fi
if [ $ENABLE_FIX_OPENBOX_DECOR == "true" ] ; then
  cp -f /opt/base/etc/openbox/rc.xml.template.bak /opt/base/etc/openbox/rc.xml.template
  sed -i 's@<decor>no<\/decor>@<decor>yes<\/decor>@g' /opt/base/etc/openbox/rc.xml.template
else
  cp -f /opt/base/etc/openbox/rc.xml.template.bak /opt/base/etc/openbox/rc.xml.template
fi
