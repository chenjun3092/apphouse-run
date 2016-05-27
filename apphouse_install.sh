#! /bin/bash

set -e

if [ $# -lt "2" ];then
    echo "usage:$0 -ip 192.168.0.1"
    exit 1
fi

count=1
while [ "$#" -ge "1" ];do
    if [ $1 = "-ip" ];then
        shift
        IP=$1
        ANSWER=$(echo $IP|awk -F '.' '$1 < 256 && $1 >= 0 && $2 < 256 && $2 >= 0 && $3 < 256 && $3 >= 0 && $4 < 256 && $4 >= 0 {print 1}')
        if [ "$ANSWER" != "1" ];then
            echo "usage:$0 -ip 192.168.0.1"
            exit 1
        fi
    fi
    let count=count+1
    shift
done

docker run --privileged=true \
    -e HOST_IP=$IP \
    -e APPHOUSE_DEV=true \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker:/var/lib/docker \
    -v /var/local/apphouse/config:/var/lib/registry_Deploy/install/config \
    -v /var/local/apphouse/storage:/var/lib/registry_Deploy/install/storage \
    index.alauda.cn/youruncloud/apphouse:v1.0.2.101
    #apphouse:env1.0
    #apphouse:v1.0.2.100.099
    #index.youruncloud.com/apphouse/apphouse:v1.0.2.100
