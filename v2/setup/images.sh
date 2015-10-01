#!/bin/bash

# pull down images serially to avoid a FS layer clobbering bug in docker 1.6.x
docker pull behance/docker-gocron-logrotate
docker pull behance/docker-sumologic
docker pull behance/docker-dd-agent
