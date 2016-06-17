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

# echo "$APPHOUSE_DEV"

# if [ "$DEV" -eq "true" -o "$DEV" -eq "TRUE" ]; then
if [ "$APPHOUSE_DEV" ]; then
    image_prefix="192.168.18.250:5002/apphouse"
        # docker login --email=20100688@qq.com --password=admin --username=admin 192.168.18.250:5002
        if [ "$RG_PWD" ]; then
            PassWord=$RG_PWD
        else
            PassWord="admin"
        fi

        if [ "$RG_USER" ]; then
            UserName=$RG_USER
        else
            UserName="admin"
        fi

        if [ "$RG_EMAIL" ]; then
            Email=$RG_EMAIL
        else
            Email="20100688@qq.com"
        fi

        docker login --email=$Email --password=$PassWord --username=$UserName 192.168.18.250:5002

    # echo "$image_prefix"
else
    image_prefix="index.youruncloud.com/apphouse"
    # echo "$image_prefix"
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

# if [ "$CORE_PORT" ]; then
    # Core_Port=$CORE_PORT
# else
    # Core_Port="9182"
# fi

# if [ "$LOG_PORT" ]; then
    # Log_Port=$LOG_PORT
# else
    # Log_Port="9200"
# fi

# if [ "$DB_PORT" ]; then
    # Db_Port=$DB_PORT
# else
    # Db_Port="27017"
# fi

# if [ "$RG_PORT" ]; then
    # Rg_Port=$RG_PORT
# else
    # Rg_Port="5002"
# fi

export CONFIG_PATH=$configPath
export STORAGE_PATH=$storagePath
export IMAGE_PREFIX=$image_prefix

export Ui_Port
export Ssl_Port

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
