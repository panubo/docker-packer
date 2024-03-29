FROM hashicorp/packer:full

ENV ANSIBLE_VERSION=2.9.25

ENTRYPOINT ["/go/bin/packer"]
WORKDIR /opt

RUN addgroup packer -g 1000 \
  && adduser packer -u 1000 -G packer -D

RUN set -xe \
  && apk add --no-cache --purge -uU sudo curl ca-certificates openssh-client python3 py-cryptography \
  && apk --update add --virtual .build-dependencies python3-dev py-pip libffi-dev openssl-dev build-base \
  && pip install --no-cache --upgrade ansible==${ANSIBLE_VERSION} \
  && apk del --purge .build-dependencies \
  && rm -rf /var/cache/apk/* /tmp/*

ENV USER packer
USER packer
