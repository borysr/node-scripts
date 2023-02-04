#!/bin/bash

# command simply get the latest lines for 'connected', 'reward'
# from the each streamer node running in the docker by node name

docker ps | grep -v NAMES | awk 'NF>1{print $NF}' | \
	xargs -I{} echo "\
	'echo Node {}';\
	'docker logs {}|grep -i claimed|tail -1'; \
	'docker logs {}|grep -i connected|tail -1';\
	'docker logs {} | grep -i claimed|wc -l'" | \
	xargs -I{} bash -c "{}"
exit 0

# the line below is modification to use container id and not a node name
docker ps -q | \
	xargs -I{} echo "\
	'echo Node {}';\
	'docker logs {}|grep -i claimed|tail -1'; \
	'docker logs {}|grep -i connected|tail -1';\
	'docker logs {} | grep -i claimed|wc -l'" | \
	xargs -I{} bash -c "{}"
