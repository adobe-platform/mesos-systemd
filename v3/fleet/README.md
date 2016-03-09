Fleet Units
====

All of these should be run on every node in every tier.

Note that most of these units have:

```
ExecStartPre=/usr/bin/systemctl is-active bootstrap
```

This **forces** them to wait until your bootstrap service completes (i.e.: in the `active` state). This is to prevent nodes from joining the cluster and immediately starting these units as soon as `fleetd` starts
