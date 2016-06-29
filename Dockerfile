FROM apphouse_alpine_base:v1.0.0

MAINTAINER youruncloud <20100688@qq.com>

RUN mkdir -p /var/lib/registry_Deploy
COPY ./registry_Deploy  /var/lib/registry_Deploy

ENV DEPLOY_PATH /var/lib/registry_Deploy

RUN chmod +x /var/lib/registry_Deploy/setenv.sh \
    && chmod +x /var/lib/registry_Deploy/start.sh

ENTRYPOINT ["/var/lib/registry_Deploy/start.sh"]
