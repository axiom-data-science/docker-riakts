#!/bin/bash
set -e

RIAK_PB_PORT=${RIAK_PB_PORT:-8087}
RIAK_HTTP_PORT=${RIAK_HTTP_PORT:-8098}
RIAK_NODE_NAME=${RIAK_NODE_NAME:-riak}
RIAK_HANDOFF_PORT=${RIAK_HANDOFF_PORT:-8099}

IFACE=${RIAK_IFACE:-eth0}

IP_ADDRESS=$(ip -o -4 addr list $IFACE | awk '{print $4}' | cut -d/ -f1)
echo "nodename = ${RIAK_NODE_NAME}@${IP_ADDRESS}" | tee -a ${RIAK_CONFIG}
echo "listener.http.internal = 0.0.0.0:${RIAK_HTTP_PORT}" | tee -a ${RIAK_CONFIG}
echo "listener.protobuf.internal = 0.0.0.0:${RIAK_PB_PORT}" | tee -a ${RIAK_CONFIG}
echo "handoff.port = ${RIAK_HANDOFF_PORT}" | tee -a ${RIAK_CONFIG}
echo "log.syslog = on" | tee -a ${RIAK_CONFIG}

if [ -s $RIAK_USER_CONFIG ]; then
    cat $RIAK_USER_CONFIG | tee -a ${RIAK_CONFIG}
fi
