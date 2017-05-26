# Local cluster

### Start nodes and haproxy
```bash
$ sudo rm -rf ./data
$ docker-compose up
```

### Join cluster

```bash
$ IP_ADDRESS=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
$ docker exec -u riak riakts-node2 riak-admin cluster join node1@${IP_ADDRESS}
Success: staged join request for 'node2@192.168.200.210' to 'node1@192.168.200.210'

$ docker exec -u riak riakts-node3 riak-admin cluster join node1@${IP_ADDRESS}
Success: staged join request for 'node3@192.168.200.210' to 'node1@192.168.200.210'
```

### Plan cluster

```bash
$ docker exec -u riak riakts-node3 riak-admin cluster plan
=============================== Staged Changes ================================
Action         Details(s)
-------------------------------------------------------------------------------
join           'node2@192.168.200.210'
join           'node3@192.168.200.210'
-------------------------------------------------------------------------------


NOTE: Applying these changes will result in 1 cluster transition

###############################################################################
                         After cluster transition 1/1
###############################################################################

================================= Membership ==================================
Status     Ring    Pending    Node
-------------------------------------------------------------------------------
valid     100.0%     34.4%    'node1@192.168.200.210'
valid       0.0%     32.8%    'node2@192.168.200.210'
valid       0.0%     32.8%    'node3@192.168.200.210'
-------------------------------------------------------------------------------
Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

WARNING: Not all replicas will be on distinct nodes

Transfers resulting from cluster changes: 42
  21 transfers from 'node1@192.168.200.210' to 'node3@192.168.200.210'
  21 transfers from 'node1@192.168.200.210' to 'node2@192.168.200.210'
```

### Commit cluster

```bash
$ docker exec -u riak riakts-node1 riak-admin cluster commit
Cluster changes committed
```

### View status of cluster

```bash
$ docker exec -u riak riakts-node1 riak-admin cluster status
---- Cluster Status ----
Ring ready: false

+---------------------------+------+-------+-----+-------+
|           node            |status| avail |ring |pending|
+---------------------------+------+-------+-----+-------+
| (C) node1@192.168.200.210 |valid |  up   | 87.5|  34.4 |
|     node2@192.168.200.210 |valid |  up   |  9.4|  32.8 |
|     node3@192.168.200.210 |valid |  up   |  3.1|  32.8 |
+---------------------------+------+-------+-----+-------+
```
