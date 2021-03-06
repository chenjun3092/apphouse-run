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

#docker "rm" "$(docker stop $(docker ps -a|grep apphouse|awk '{print $1}'))"
contian=`docker ps -a|grep apphouse|awk '{print $1}'`
if [ "${contian}" ];then
    echo "Del contians ..."
    docker "rm" $(docker "stop" ${contian})
    echo "Del complete ..."
fi

docker run --rm --privileged=true \
    -e HOST_IP=$IP \
    -e APPHOUSE_DEV=true \
    -e HA=true \
    -e MgIps="192.168.15.23:27017,192.168.15.24:27017,192.168.15.25:27017" \
    -e HaHost="apphub.zte.com.cn" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker:/var/lib/docker \
    -v /var/local/apphouse/config:/var/lib/registry_Deploy/install/config \
    -v /var/local/apphouse/storage:/var/lib/registry_Deploy/install/storage \
    192.168.18.250:5002/apphouse/apphouse-zte-stor:v1.0.5.119
    #192.168.18.250:5002/apphouse/apphouse-zte-conf:v1.0.5.119
    #-e HA=true \
    #-e MgIps="192.168.15.23:27017,192.168.15.24:27017,192.168.15.25:27017" \
    #-e HaHost="192.168.15.25" \
    #-e HA=true \
    #--entrypoint=/bin/bash \
    #192.168.18.250:5002/apphouse/apphouse:v1.0.2.106
    #-e TAG_PREFIX=192.168.18.250:5002/oem \
    #apphouse:upgrade
    #index.youruncloud.com/apphouse/apphouse:v1.0.2.108

#docker run --rm --privileged=true \
#    -e HOST_IP=$IP \
#    -e APPHOUSE_DEV=true \
#    -e HA=true \
#    -e MgIps="192.168.15.28:27017,192.168.15.29:27017,192.168.15.30:27017" \
#    -e HaHost="192.168.15.69" \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v /var/lib/docker:/var/lib/docker \
#    -v /var/local/apphouse/config:/var/lib/registry_Deploy/install/config \
#    -v /var/local/apphouse/storage:/var/lib/registry_Deploy/install/storage \
#    192.168.18.250:5002/apphouse/apphouse-zte:v1.0.5.119
