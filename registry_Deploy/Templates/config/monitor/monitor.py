#!/usr/bin/env python
import commands
import sys
import types
import json

container = {"install_registry_1", "install_registry_collector_auth_1", "install_logstash_1", "install_elasticsearch_1"}
registry_ui = "install_registryui_1"

def get_container_info(container):
    msg = commands.getoutput('docker inspect '+container)
    data = json.loads(msg)
    return data[0]

def get_container_status(data):
    return data['State']['Running']

def stop_container_ui(container_ui_name):
    return commands.getoutput('docker stop '+container_ui_name)

def start_container_ui(container_ui_name):
    return commands.getoutput('docker start '+container_ui_name)


if get_container_status(get_container_info(registry_ui)):
    for i in container:
        if not get_container_status(get_container_info(i)):
            stop_container_ui(registry_ui)

