FROM  apphouse/autoinstall:base0.1

#RUN export PATH=$PATH:/venv/bin/docker-compose
RUN mkdir -p /var/lib/registry_Deploy
COPY ./registry_Deploy  /var/lib/registry_Deploy

ENV DEPLOY_PATH /var/lib/registry_Deploy

RUN chmod +x /var/lib/registry_Deploy/setenv.sh

#COPY ./start.sh /var/lib/registry_Deploy/
RUN chmod +x /var/lib/registry_Deploy/start.sh

#VOLUME ["/var/run/docker.sock"]
#VOLUME ["/var/lib/registry_Deploy/config"]
#VOLUME ["/var/lib/docker"]

ENTRYPOINT ["/var/lib/registry_Deploy/start.sh"]

