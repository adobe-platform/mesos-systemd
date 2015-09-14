# mesos-systemd

Behance scripts to bootstrap a CoreOS cluster & run Mesos/Marathon/Chronos/Zookeeper-Exhibitor

DISCLAIMER:
====

This repository may reference private repositories or scripts. Most should be replaceable with your own, but either way - proceed with caution as this project is highly experimental and certain nuances may not be well documented. If you want to use this repo, you may have to prune the code a bit and edit/delete certain files.

V2 Concepts
====

The purpose of this repository is to house all setup scripts and systemd/fleetd units in a central location, separate of our infrastructure provisioning scripts (cloudformation).

All setup behavior is defined in the [`init`](https://github.com/behance/mesos-systemd/blob/master/init) script.

Assumptions:

- Your infrastructure has 3 tiers: `control`, `proxy`, `worker`
- ALL nodes run a `bootstrap.service`, whatever that may be.
- Some of the scripts require `/etc/environment` to contain certain variables (usually cloudformation parameters such as route53 entries)
- S3 buckets are set correctly and all required credential files (SSH keys, datadog & sumologic credentials) are properly provided to `init` & can be downloaded using [behance/docker-aws-s3-downloader](https://github.com/behance/docker-aws-s3-downloader)
