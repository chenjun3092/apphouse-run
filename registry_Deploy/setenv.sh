#! /bin/bash

# This file is subject to the terms and conditions defined in
# file 'LICENSE.txt', which is part of this source code package.

set -e

if [ $# -lt "2" ];then
    echo "usage:$0 -ip 192.168.0.1"
    exit 1
fi

cd $DEPLOY_PATH

composeYml=./install/docker-compose.yml

if [ -f ./install/config/docker-compose.yml ]; then
    rm -rf ./install/config/docker-compose.yml
fi

mkdir -p ./install/config
cp -rf ./Templates/config/* ./install/config
if [ -f ./install/config/docker-compose.yml ]; then
    mv ./install/config/docker-compose.yml ./install/docker-compose.yml
fi
cp -rf ./Templates/storage/* ./install/storage

sed -i "s#<IMAGE_ADDR>#$IMAGE_ADDR#g" $composeYml
sed -i "s#<configPath>#$CONFIG_PATH#g" $composeYml
sed -i "s#<storagePath>#$STORAGE_PATH#g" $composeYml
# sed -i "s#<UI_IMAGE>#$UI_IMAGE#g" $composeYml
# sed -i "s#<REGISTRY_IMAGE>#$REGISTRY_IMAGE#g" $composeYml
# sed -i "s#<AUTH_IMAGE>#$AUTH_IMAGE#g" $composeYml
# sed -i "s#<ELA_IMAGE>#$ELA_IMAGE#g" $composeYml
# sed -i "s#<LOGSTASH_IMAGE>#$LOGSTASH_IMAGE#g" $composeYml

count=1
while [ "$#" -ge "1" ];do
    if [ $1 = "-ip" ];then
        shift
        IP=$1
        ANSWER=$(echo $IP|awk -F '.' '$1 < 255 && $1 >= 0 && $2 < 255 && $2 >= 0 && $3 < 255 && $3 >= 0 && $4 < 255 && $4 >= 0 {print 1}')
        if [ "$ANSWER" != "1" ];then
            echo "usage:$0 -ip 192.168.0.1"
            exit 1
        fi
        # echo "ip = $IP"
    fi
    let count=count+1
    shift
done

sed -i "s/PrivateRegistryHostIP/$IP/g" `grep PrivateRegistryHostIP ./install -rl`
