#!/bin/bash

source /etc/environment

cat /home/core/.etcdrootpassword | while read line; do echo "$line"; done
