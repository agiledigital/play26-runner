#!/bin/bash -x
set -e

if [ -f "/home/runner/artifacts/RUNNING_PID" ]
then
   rm /home/runner/artifacts/RUNNING_PID
fi

export EXTERNAL_IP=`ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`

echo "Got external ip [$EXTERNAL_IP]."

echo "Environment start"
env
echo "Environment start"

echo "/etc/hosts start"
cat /etc/hosts
echo "/etc/hosts end"

# Set the timezone if TZ is set
if [ ! -z "$TZ" ]; then
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" >  /etc/timezone && \
    echo "Container timezone set to: $TZ"
fi

exec "/home/runner/artifacts/bin/dist" "-J-XX:+ExitOnOutOfMemoryError" "-Dconfig.resource=combined.conf" "-Dplay.evolutions.db.default.autoApply=true" "-DapplyEvolutions.default=true" "$@"