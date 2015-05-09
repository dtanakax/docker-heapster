#!/bin/bash
set -e

if [ $CADVISOR_SERVICE_IPS != "**None**" ]; then
    HOSTS_FNAME=/var/run/heapster/hosts
    rm -f $HOSTS_FNAME
    touch $HOSTS_FNAME
    echo "{" >> $HOSTS_FNAME
    echo "  \"items\": [" >> $HOSTS_FNAME

    items=()
    IFS=';'
    idx=1
    for ip in $CADVISOR_SERVICE_IPS; do
        items+=("{\"name\":\"cadvisor${idx}\", \"ip\":\"${ip}\"}")
        idx=$((idx+1))
    done
    echo "$(IFS=,; echo "    ${items[*]}")" >> $HOSTS_FNAME
    echo "  ]" >> $HOSTS_FNAME
    echo "}" >> $HOSTS_FNAME
fi

exec /usr/bin/heapster "$@"

