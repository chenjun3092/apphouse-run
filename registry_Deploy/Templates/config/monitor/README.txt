apphouse安装完后在apphouse主机上配置monitor监控每台主机上各容器模块的状态:
将monitor目录放于安装目录下,cd monitor进入目录执行以下命令：
echo "* * * * * root bash `pwd`/monitor.sh `pwd` >/dev/null 2>&1" >> /etc/crontab 
