#!/bin/sh

docker ps -a | grep 'test' | awk '{print $1}' | xargs docker rm -f
docker build -t test .
#docker run -d -e VB1_PORT_18083_TCP=192.168.0.21:18083 -e VB1_NAME=QUARK -p 88:80 --name test test
docker run -d -p 88:80 --name test test
docker exec -ti test sh

