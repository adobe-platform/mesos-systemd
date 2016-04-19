#!/bin/bash
# SPLUNK_FORWARD_SERVER shoudl be delcared as a config in the setup-credentials util

source /etc/environment

etcdctl set /splunk/SPLUNK_FORWARD_SERVER $SPLUNK_FORWARD_SERVER
etcdctl set /images/splunkforwarder "adobeplatform/docker-splunk:latest"
