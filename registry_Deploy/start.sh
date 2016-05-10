#! /bin/bash

# This file is subject to the terms and conditions defined in
# file 'LICENSE.txt', which is part of this source code package.
# https://<YourHostIP>:443 or http://<YourHostIP>:80.\n


set -e


Welcome_display="
 --------------------------------------------------------------\n
Welcome to use AppHouse!\n
--------------------------------------------------------------\n"
echo -e $Welcome_display

docker version
if [ $? -ne 0 ];then
    echo "server docker version doesn't match apphouse docker version"
    echo "please install correct docker version "
    exit 1
fi

inspectProg="/var/lib/registry_Deploy/inspect"
configPath=`$inspectProg | cut -d ":" -f1`
storagePath=`$inspectProg | cut -d ":" -f2`
if [ -z $configPath ] || [ -z $storagePath ];then
    echo "can't get ConfigPath or StoragePath"
    echo "please check if you have run container with"
    echo "-v <hostConfigLocation>:/var/lib/registry_Deploy/config and "
    echo "-v <hostStorageLocation>:/var/lib/registry_Deploy/storage"
    exit 1
fi

# AUTH_IMAGE="index.alauda.cn/cloudsoar/registry_collector_auth:0.8.8"
# UI_IMAGE="index.alauda.cn/cloudsoar/registry_ui:0.8.2"
# REGISTRY_IMAGE="index.alauda.cn/cloudsoar/registry:2.3.0"
# ELA_IMAGE="index.alauda.cn/cloudsoar/elasticsearch:0.8"
# LOGSTASH_IMAGE="index.alauda.cn/cloudsoar/logstash:0.8"

# if [ -z $AUTH_IMAGE ] ;then
    # echo "env AUTH_IMAGE is empty; container must run with AUTH_IMAGE "
    # exit 1
# fi

# if [ -z $UI_IMAGE ] ;then
    # echo "env UI_IMAGE is empty; container must run with UI_IMAGE "
    # exit 1
# fi

# if [ -z $REGISTRY_IMAGE ]; then
    # echo "env REGISTRY_IMAGE is empty; container must run with REGISTRY_IMAGE "
    # exit 1
# fi

# if [ -z $ELA_IMAGE ]; then
    # echo "env ELA_IMAGE is empty; container must run with ELA_IMAGE "
    # exit 1
# fi

# if [ -z $LOGSTASH_IMAGE ]; then
    # echo "env LOGSTASH_IMAGE is empty; container must run with LOGSTASH_IMAGE "
    # exit 1
# fi

export CONFIG_PATH=$configPath
export STORAGE_PATH=$storagePath

. $DEPLOY_PATH/setenv.sh -ip $HOST_IP
cd $DEPLOY_PATH/install

Wait_notes="
 --------------------------------------------------------------\n
This may take a long time to download, please be patient\n
to wait for completion!
--------------------------------------------------------------\n"
echo -e $Wait_notes

$VENV_BIN/docker-compose up -d

wait

License_display="
 --------------------------------------------------------------\n
Install Success, you can access private repository via\n
http://<YourHostIP>\n
If you have any questions, please access www.youruncloud.com,\n
thanks.\n
--------------------------------------------------------------\n"
echo -e $License_display

exit 0
