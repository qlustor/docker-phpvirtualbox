#!/bin/sh

docker ps -a | grep 'test' | awk '{print $1}' | xargs docker rm -f
docker build -t test .
docker run -d -p 88:80 --name test test
docker exec -ti test sh

