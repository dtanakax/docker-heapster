#!/bin/bash
set -e

if [ "$1" = "/usr/bin/heapster" ]; then
    EXTRA_ARGS=""

    # If in Kubernetes, target the master.
    if [ $KUBERNETES_RO_SERVICE_HOST != "**None**" ]; then
        EXTRA_ARGS="--source=kubernetes:${KUBERNETES_RO_SERVICE_HOST}"
    elif [ $COREOS_FLEET_SERVICE_HOST != "**None**" ]; then
        EXTRA_ARGS="--source=cadvisor:coreos?fleetEndpoint=${COREOS_FLEET_SERVICE_HOST}"
    fi

    case $SINK in
        'influxdb') 
            if [ -n $INFLUXDB_HOST ]; then
                EXTRA_ARGS="--sink influxdb:${INFLUXDB_HOST} $EXTRA_ARGS"
            else
                echo "Influxdb host invalid."
                exit 1
            fi
            ;;
        'gcm') 
            EXTRA_ARGS="--sink gcm $EXTRA_ARGS"
            ;;
    esac

    exec "$@" $EXTRA_ARGS
else
    exec "$@"
fi