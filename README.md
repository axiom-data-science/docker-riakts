# riak-ts on Docker

Nothing fancy, just a stable riak-ts docker container. Bring your own clustering. See [the example](example/) for an example local cluster and haproxy setup.

## Usage

#### Configuration

There are some configurable environmental variables that will set some riak settings. See [how the config is set](init/02_set_config.sh) for further explanation.

*  **`RIAK_PB_PORT`** (default: `8087`)

    ```bash
    listener.protobuf.internal = 0.0.0.0:${RIAK_PB_PORT}
    ```

*  **`RIAK_HTTP_PORT`** (default: `8098`)

    ```bash
    listener.http.internal = 0.0.0.0:${RIAK_HTTP_PORT}
    ```

*  **`RIAK_IFACE`** (default: `eth0`)

    `RIAK_IFACE` is used to find the device that the `IP_ADDRESS` is pulled from, see `RIAK_NODE_NAME`.

*  **`RIAK_NODE_NAME`** (default: `riak`)

    ```bash
    nodename = ${RIAK_NODE_NAME}@${IP_ADDRESS}
    ```

    `IP_ADDRESS` is set to `ip -o -4 addr list $RIAK_IFACE | awk '{print $4}' | cut -d/ -f1)`.

*  **`RIAK_HANDOFF_PORT`** (default: `8099`)

    ```bash
    handoff.port = ${RIAK_HANDOFF_PORT}
    ```

*  **`RIAK_USER_CONFIG`**

    Path to a riak configuration file. This file will be appended to the end of the riak config file before start. These will overwrite anything defined in the main riak config file, including those set above via environmental variables.


#### Volumes

*  **`/var/log/riak`** - Logs from riak are processed through `syslogd` and are avaiable through `docker logs` and are also saved to disk here. Mount for logs file access.

*  **`/var/lib/riak`** - Riak data. Mount a volume here to persist the riak data between container restarts.
