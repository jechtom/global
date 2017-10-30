#!/bin/bash

docker node update --label-add cluster-name=beta hehoserver-beta
docker node update --label-add cluster-node-index=1 hehoserver-beta

docker node update --label-add cluster-name=charlie hehoserver-charlie
docker node update --label-add cluster-node-index=1 hehoserver-charlie

docker node update --label-add cluster-name=charlie hehoserver-charlie2
docker node update --label-add cluster-node-index=2 hehoserver-charlie2