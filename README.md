# mesos-systemd

Adobe Platform scripts to bootstrap a CoreOS [`cluster`](https://github.com/adobe-platform/mesos-cluster) & run Mesos/Marathon/Chronos/Zookeeper-Exhibitor
Provides node-level services as [`Fleet Units`](https://coreos.com/using-coreos/clustering/) for every machine in the cluster.
Most services (logging, metrics, monitoring) run on all nodes, some only run on specific tiers based on the metadata that is injected into Fleet.

All Nodes:
- Datadog (monitoring)
- Sysdig (monitoring)
- Sumologic (log collector)
- Logrotate
- Docker image cleanup
- SSHD

Control Tier Nodes:
- Mesos Master
- Marathon
- Exhibitor (for Zookeeper)
- Chronos
- [`Flight Director`](https://github.com/adobe-platform/flight-director)

Proxy Tier Nodes:
- [`CAPCOM`](https://github.com/adobe-platform/capcom)
- Heatshield Proxy

Worker Tier Nodes:
- Mesos Slave


DISCLAIMER:
====

This repository may reference private repositories or scripts. Most should be replaceable with your own, but either way - proceed with caution as this project is highly experimental and certain nuances may not be well documented. If you want to use this repo, you may have to prune the code a bit and edit/delete certain files.

V2 Concepts
====

The purpose of this repository is to house all setup scripts and systemd/fleetd units in a central location, separate of our infrastructure provisioning scripts (cloudformation).

All setup behavior is defined in the [`init`](https://github.com/adobe-platform/mesos-systemd/blob/master/init) script.

Assumptions:

- Your infrastructure has 3 tiers: `control`, `proxy`, `worker`
- ALL nodes run a `bootstrap.service`, whatever that may be.
- Some of the scripts require `/etc/environment` to contain certain variables (usually cloudformation parameters such as route53 entries)
- S3 buckets are set correctly and all required credential files (SSH keys, datadog & sumologic credentials) are properly provided to `init` & can be downloaded using [behance/docker-aws-s3-downloader](https://github.com/adobe-platform/docker-aws-s3-downloader)

#### `init` bootstrap

Our `bootstrap.service` just clones this repo and runs the `init` script.

From there, it does a couple of things:

1. ensure that any credentials/secure files are downloaded from S3 (to allow docker & git to pull private dependencies)
2. configure SSH configs to allow github.com access
3. copy `.dockercfg` into `/root` # TODO: refactor process as this is a hack
4. runs ALL scripts in `v2/setup`
    - these scripts will always be run with `sudo` (i.e.: as root)
    - set things up like create motds, aliases, dropins for various services
5. starts up tier-specific template units that are specified by the running machines' IP (provided by CoreOS / cloudinit)
    - these are started via fleet, event though they are NOT global units and run on specific machines
    - rationale for this is to give us granular control over certain units, such as mesos-slaves. It allows us to control individual nodes, or perform rolling actions (such as deploys) while retaining visibility into the cluster as a whole.
6. submits and starts generic fleet units

#### Docker Image ID etcd keys (under `/images`):

- mesos-master
- mesos-slave
- marathon
- chronos
- zk
- capcom (private)
- capcom2 (private)
- fd (private)

Set these if you want your units to run different docker containers.

