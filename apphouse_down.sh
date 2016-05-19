#! /bin/bash

sudo docker stop $(docker ps -a|grep youruncloud|awk '{print $1}')

sudo docker rm $(docker ps -a|grep youruncloud|awk '{print $1}')
#docker stop $(docker ps -a|grep cloudsoar|awk '{print $1}')
#docker rm $(docker ps -a|grep cloudsoar|awk '{print $1}')
