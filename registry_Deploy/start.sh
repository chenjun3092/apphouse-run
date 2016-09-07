#! /bin/bash

# This file is subject to the terms and conditions defined in
# file 'LICENSE.txt', which is part of this source code package.
# https://<YourHostIP>:443 or http://<YourHostIP>:80.\n

set -e

Welcome_display="\n
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

if [ "${HA}" == "true" ] && [ -z ${MgIps} ]; then
    echo "HA mode MgIps must be set up!"
    exit 1
fi
if [ "${HA}" == "true" ] && [ -z ${HaHost} ];then
    echo "HA mode HaHost must be set up!"
    exit 1
fi

# echo "$APPHOUSE_DEV"

if [ "${TAG_PREFIX}" ]; then
    image_prefix="${TAG_PREFIX}"
else if [ "${APPHOUSE_DEV}" == "true" ]; then
    image_prefix="192.168.18.250:5002/apphouse"
else
    image_prefix="index.youruncloud.com/apphouse"
fi

fi

if [ "$UI_PORT" ]; then
    Ui_Port=$UI_PORT
    # echo "$UI_PORT"
else
    Ui_Port="80"
    # echo "$UI_PORT"
fi

if [ "$SSL_PORT" ]; then
    Ssl_Port=$SSL_PORT
else
    Ssl_Port="443"
fi

export CONFIG_PATH=$configPath
export STORAGE_PATH=$storagePath
export IMAGE_PREFIX=$image_prefix
export HA=${HA}
export replSetIp=${MgIps}
#export CA=${CA}
export Ui_Port
export Ssl_Port
export HAHOSTIP=${HaHost}

# export Db_Port
# export Rg_Port
# export Core_Port
# export Log_Port

. $DEPLOY_PATH/setenv.sh -ip $HOST_IP
cd $DEPLOY_PATH/install

Wait_notes="\n
--------------------------------------------------------------\n
Start run AppHouse!
This may take a long time to ready images. \n
Please wait for completion...\n
--------------------------------------------------------------\n"
echo -e $Wait_notes

docker-compose up -d
#$VENV_BIN/docker-compose up -d

wait

License_display="\n
--------------------------------------------------------------\n
Install Success, you can access private repository via\n
http://<YourHostIP>\n
Default username: admin\n
Default password: 123456\n
If you have any questions, please access www.youruncloud.com,\n
thanks.\n
--------------------------------------------------------------\n"
echo -e $License_display

exit 0
