FROM  centos:7

RUN yum install -y \
    curl \
    python \
    docker


# RUN curl -s -L https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 > /usr/bin/docker; chmod +x /usr/bin/docker

RUN curl -s https://bootstrap.pypa.io/get-pip.py > get-pip.py && python get-pip.py && rm get-pip.py

RUN curl -s http://stedolan.github.io/jq/download/linux64/jq  >/usr/bin/jq && chmod +x /usr/bin/jq

RUN pip install virtualenv
RUN mkdir /venv
RUN cd /venv
RUN virtualenv venv && source /venv/bin/activate && pip install docker-compose && pip install docker-py #&& /venv/bin/deactivate
ENV VENV_BIN /venv/bin

