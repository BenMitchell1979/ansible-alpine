FROM alpine:3.13.5

# Metadata
LABEL maintainer="BenTheBuilder <BenTheBuilder@cloudgeek.xyz>" \
      org.label-schema.url="https://github.com/BenTheBuilder/docker-ansible-build/README.md" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.version=${ANSIBLE_VERSION} \
      org.label-schema.vcs-url="https://github.com/BenTheBuilder/docker-ansible-build.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.description="Custom Built Docker image for using Ansible against Windows." \
      org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        py3-pip \
        py3-cryptography \
        rsync \
        sshpass

RUN apk --update add --virtual \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base \
        curl

RUN apk --update add \
       krb5 \
       krb5-dev

RUN pip3 install --upgrade \
        pip \
        cffi 

RUN apk add ansible

RUN pip3 install --upgrade pywinrm[kerberos] \
 && pip3 install pywinrm \
 && rm -rf /var/cache/apk/*

COPY entrypoint /usr/local/bin/

WORKDIR /ansible

ENTRYPOINT ["entrypoint"]

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]