#!/bin/bash

# command displays beneficiary address
# from the each streamer node running in the docker by node name

docker ps | grep -v NAMES | awk 'NF>1{print $NF}' | \
	xargs -I{} echo "\
	'echo Node {}';\
        'docker exec  {} grep -i beneficiary /home/streamr/.streamr/config/default.json'" | \
	xargs -I{} bash -c "{}"
exit 0

# the line below is modification to use container id and not a node name
docker ps -q | \
	xargs -I{} echo "\
	'echo Node {}';\
        'docker exec  {} grep -i beneficiary /home/streamr/.streamr/config/default.json'" | \
	xargs -I{} bash -c "{}"
