
FROM centos:7

MAINTAINER pytorch "yibitx@126.com"

ENV PYTORCH 0.0.1

RUN set -ex \
    && yum install -q -y python \
    curl jq vim git-core lsof \
    && easy_install pip

RUN mkdir -p /pytorch

COPY . /pytorch

WORKDIR /pytorch

RUN set -ex \
    && sh tools/setup \
    && pip install -r requirements.txt

CMD ["bash"]

