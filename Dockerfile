ARG BASE_CONTAINER=ubuntu:lunar
FROM $BASE_CONTAINER

LABEL tags="python, microframework, nature-inspired-algorithms, swarm-intelligence, optimization-algorithms"
LABEL maintainer="Klemen Berkovic <roxor@gmail.com>"
LABEL github="https://github.com/NiaOrg"
LABEL github-docker="https://github.com/NiaOrg/NiaPy-Docker"
LABEL description="Nature-inspired algorithms are a very popular tool for solving optimization problems. Numerous variants of nature-inspired algorithms have been developed since the beginning of their era. To prove their versatility, those were tested in various domains on various applications, especially when they are hybridized, modified or adapted. However, implementation of nature-inspired algorithms is sometimes a difficult, complex and tedious task. In order to break this wall, NiaPy is intended for simple and quick use, without spending time for implementing algorithms from scratch."

ARG PYTHON_VERSION_MAJOR=3
ARG PYTHON_VERSION_MINOR_FIRST=11
ARG PYTHON_VERSION_MINOR_SECOND=0

ENV PYTHON_VERSION=${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST}.${PYTHON_VERSION_MINOR_SECOND}
ENV NIA_GIT=https://github.com/NiaOrg/NiaPy.git
ENV NIA_EXAMPLES_GIT=https://github.com/NiaOrg/NiaPy-examples.git
ENV SHELL=/bin/bash

USER root
WORKDIR /opt

## Install Python
RUN apt update \
 && apt install -y curl gcc g++ make libc-dev dpkg-dev ca-certificates zlib1g-dev liblzma-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev
RUN curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -o Python-${PYTHON_VERSION}.tgz \
 && tar xzf Python-${PYTHON_VERSION}.tgz \
 && cd Python-${PYTHON_VERSION}
RUN ./configure --prefix=/usr/local --enable-optimizations --enable-ipv6 && make -j$(nproc) \
 && make install
RUN cd /opt \
 && rm -f /opt/Python-${PYTHON_VERSION}.tgz \
 && rm -rf /opt/Python-${PYTHON_VERSION}

## Install additional programs
RUN apt update \
 && apt install -y git software-properties-common
# NeoVim
RUN add-apt-repository ppa:neovim-ppa/unstable \
 && apt update \
 && apt install -y neovim
# Python pip
RUN /usr/local/bin/pip${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} install --upgrade pip \
 && /usr/local/bin/pip${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} install --upgrade pipenv

## Install NiaPy
RUN git clone https://github.com/NiaOrg/NiaPy.git /opt/NiaPy \
 && cd /opt/NiaPy
# TODO

## Set default programs
# Python
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} 0 \
 && update-alternatives --config python
RUN update-alternatives --install /usr/bin/python${PYTHON_VERSION_MAJOR} python${PYTHON_VERSION_MAJOR} /usr/local/bin/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} 0 \
 && update-alternatives --config python${PYTHON_VERSION_MAJOR}
# Pip
RUN update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} 0 \
 && update-alternatives --config pip
RUN update-alternatives --install /usr/bin/pip${PYTHON_VERSION_MAJOR} pip${PYTHON_VERSION_MAJOR} /usr/local/bin/pip${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR_FIRST} 0 \
 && update-alternatives --config pip${PYTHON_VERSION_MAJOR}

CMD /bin/bash
