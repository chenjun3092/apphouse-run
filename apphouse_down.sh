#! /bin/bash

sudo docker stop $(docker ps -a|grep apphouse|awk '{print $1}')
sudo docker rm $(docker ps -a|grep apphouse|awk '{print $1}')
