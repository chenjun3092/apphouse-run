#! /bin/bash

docker stop $(docker ps -a|grep youruncloud|awk '{print $1}')

docker rm $(docker ps -a|grep youruncloud|awk '{print $1}')


