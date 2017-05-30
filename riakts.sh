#!/bin/bash

# Increase open file descriptor
ulimit -n 65536

# Ensure correct ownership and permissions on volumes
chown -R riak:riak ${RIAK_DATA} ${RIAK_LOGS}
chmod 755 ${RIAK_DATA} ${RIAK_LOGS}

exec /sbin/setuser riak "$(ls -d /usr/lib/riak/erts*)/bin/run_erl" "/tmp/riak" "${RIAK_LOGS}" "exec /usr/sbin/riak console"
