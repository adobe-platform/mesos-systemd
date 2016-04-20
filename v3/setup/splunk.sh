#!/bin/bash
# SPLUNK_FORWARD_SERVER is declard in infrastructure config/secrets.json

source /etc/environment

etcdctl set /images/splunkforwarder "adobeplatform/docker-splunk:latest"
