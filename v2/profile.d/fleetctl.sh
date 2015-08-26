#!/bin/bash

source /etc/environment
export FLEETCTL_ENDPOINT=unix:///var/run/fleet.sock
export FLEETCTL_EXPERIMENTAL_API=true
