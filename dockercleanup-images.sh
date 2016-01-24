#!/bin/sh

# Remove intermediary and unused images.
docker rmi $(docker images -aq -f "dangling=true")

