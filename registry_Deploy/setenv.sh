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

idir=./install
tdir=./Templates

nginx80Conf=config/nginx_conf/registry_ui.conf
nginx443Conf=config/nginx_conf/docker_registry.conf
authConf=config/registry_collector/config.conf
registryConf=./install/config/registry/config.yml

serverCrt=config/nginx_conf/ssl_auth/server.crt
serverKey=config/nginx_conf/ssl_auth/server.key
webLog=storage/registry_collector/Trace/logs/web.log

if [ ! -d ./install/config ]; then
    mkdir -p ./install/config
else
    if [ -f ${idir}/${serverCrt} ]; then
        #rm -rf ${tdir}/${serverCrt}
        cp ${idir}/${serverCrt} ${tdir}/${serverCrt}
    fi

    if [ -f ${idir}/${serverKey} ]; then
        #rm -rf ${tdir}/${serverKey}
        cp ${idir}/${serverKey} ${tdir}/${serverKey}
    fi
fi

if [ ! -d ./install/storage ]; then
    mkdir -p ./install/storage
else
    if [ -f ${idir}/${webLog} ]; then
        cp ${idir}/${webLog} ${tdir}/${webLog}
    fi
fi

#if [ -f ${idir}/config/.down ]; then

    #cp ${idir}/config/.down ${idir}/docker-compose.yml
    ##cd ./install
    #cd ${idir}
    ##docker-compose down
    ##trap "" 1 2 3 15
    #docker-compose stop
    #sleep 1
    #sleep 1
    #sleep 1
    #sleep 1
    #sleep 1
    #contain=`docker ps -a|grep Exited|awk '{print $1}'`
    #sleep 1
    #if [ "${contain}" ]; then
        #docker "stop" ${contain}
    #fi
    #sleep 1
    #contain=`docker ps -a -q --filter "status=exited"`
    #sleep 1
    #if [ "${contain}" ]; then
        #while [ 0 -eq 0 ]
        #do
            #echo "Del contains ..."
            #echo "${contain}"
            #OK=`docker "rm" "-f" ${contain}`
            ##echo $?
            ##echo ${OK}
            ## check and retry     
            #if [ $? -eq 0 ]; then
                #rm -rf ${idir}/config/.down
                #echo "Del complete ..."
                #break;
            #else
                #echo "Error occur, retry in 2 seconds ..."
                #sleep 2
            #fi
        #done
    #else
        #echo "Can't stoping ${contain}. Please manually delete ..."
    #fi

##    contain=`docker ps -a|grep Exited|awk '{print $1}'`
    ##if [ "${contain}" ]; then
        ###docker "rm" "-f" ${contain}
        ##while [ 0 -eq 0 ]
        ##do
            ##echo "Del contains ..."
            ##echo "${contain}"
            ##OK=`docker "rm" "-f" ${contain}`
            ###echo $?
            ###echo ${OK}
            ### check and retry     
            ##if [ $? -eq 0 ]; then
                ##rm -rf ${idir}/config/.down
                ##echo "Del complete ..."
                ##break;
            ##else
                ##echo "Error occur, retry in 2 seconds ..."
                ##sleep 2
            ##fi
        ##done
##    fi
    ##trap 1 2 3 15

    #cd $DEPLOY_PATH
    ##rm -rf ./install/config/docker-compose.yml
#fi

if [ -f ${idir}/${nginx80Conf} ]; then
    # get old setting
    sed -i '/^ *#/d' ${idir}/${nginx80Conf}
    line=`sed -n '/'"server_name"'/=' ${idir}/${nginx80Conf}`
    stmp=`awk -F":" -v n=${line} 'NR==n{print $1}' ${idir}/${nginx80Conf}`

    # set to Templates
    sed -i '/^ *#/d' ${tdir}/${nginx80Conf} 
    Templine=`sed -n '/'"server_name"'/=' ${tdir}/${nginx80Conf}`
    sed -i "${Templine}s/^.*$/${stmp}/" ${tdir}/${nginx80Conf}
fi

if [ -f ${idir}/${nginx443Conf} ]; then
    # get old setting
    sed -i '/^ *#/d' ${idir}/${nginx443Conf}
    line=`sed -n '/'"server_name"'/=' ${idir}/${nginx443Conf}`
    stmp=`awk -F":" -v n=${line} 'NR==n{print $1}' ${idir}/${nginx443Conf}`

    # set to Templates
    sed -i '/^ *#/d' ${tdir}/${nginx443Conf} 
    Templine=`sed -n '/'"server_name"'/=' ${tdir}/${nginx443Conf}`
    sed -i "${Templine}s/^.*$/${stmp}/" ${tdir}/${nginx443Conf}
fi

if [ -f ${idir}/${authConf} ]; then
    # get old setting
    commonname=`jq .common_name "${idir}/${authConf}"|sed 's/\"//g'`

    # set to Templates
    sed -i -r 's/(.*common_name":").*(".*)/\1'"${commonname}"'\2/' "${tdir}/${authConf}"
fi

cp -rf ./Templates/config/* ./install/config
if [ -f ./install/config/docker-compose.yml ]; then
    mv ./install/config/docker-compose.yml ./install/docker-compose.yml
    #cp -rf ./install/config/docker-compose.yml ./install/docker-compose.yml
fi
cp -rf ./Templates/storage/* ./install/storage

#sed -i "s#<IMAGE_ADDR>#$IMAGE_ADDR#g" $composeYml
sed -i "s#<configPath>#$CONFIG_PATH#g" $composeYml
sed -i "s#<storagePath>#$STORAGE_PATH#g" $composeYml
# sed -i "s#<UI_IMAGE>#$UI_IMAGE#g" $composeYml
# sed -i "s#<REGISTRY_IMAGE>#$REGISTRY_IMAGE#g" $composeYml
# sed -i "s#<AUTH_IMAGE>#$AUTH_IMAGE#g" $composeYml
# sed -i "s#<ELA_IMAGE>#$ELA_IMAGE#g" $composeYml
# sed -i "s#<LOGSTASH_IMAGE>#$LOGSTASH_IMAGE#g" $composeYml
sed -i "s#<image_prefix>#$IMAGE_PREFIX#g" $composeYml
sed -i "s#<UI_PORT>#$Ui_Port#g" $composeYml
sed -i "s#<UI_PORT>#$Ui_Port#g" $registryConf
sed -i "s#<SSL_PORT>#$Ssl_Port#g" $composeYml
# sed -i "s#<CORE_PORT>#$Core_Port#g" $composeYml
# sed -i "s#<DB_PORT>#$Db_Port#g" $composeYml
# sed -i "s#<LOG_PORT>#$Log_Port#g" $composeYml
# sed -i "s#<RG_PORT>#$Rg_Port#g" $composeYml

if [ -f ${composeYml} ]; then
    cp -rf ${composeYml} ${idir}/config/.down
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
        # echo "ip = $IP"
    fi
    let count=count+1
    shift
done

sed -i "s/PrivateRegistryHostIP/$IP/g" `grep PrivateRegistryHostIP ./install/config -rl`
