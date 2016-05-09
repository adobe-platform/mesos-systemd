#!/bin/bash

source /etc/environment

cat /home/core/.etcdrootuser | while read line; do echo "$line"; done
