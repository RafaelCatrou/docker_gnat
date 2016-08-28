# --------------------------------------------------------------------------------------------------
# LICENSE
# --------------------------------------------------------------------------------------------------
# ! # License #
# ! Copyright 2016 Rafael CATROU
# !
# ! Licensed under the Apache License, Version 2.0 (the "License");
# ! you may not use this file except in compliance with the License.
# ! You may obtain a copy of the License at
# !
# !     http://www.apache.org/licenses/LICENSE-2.0
# !
# ! Unless required by applicable law or agreed to in writing, software
# ! distributed under the License is distributed on an "AS IS" BASIS,
# ! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# ! See the License for the specific language governing permissions and
# ! limitations under the License.
# !
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Base OS + tools
# --------------------------------------------------------------------------------------------------
FROM ubuntu:16.04
MAINTAINER Rafael Catrou <rafael@localhost>

RUN \
    apt-get update -y && \
    apt-get upgrade -y

RUN \
    apt-get install -y make && \
    apt-get install -y sudo && \    
    apt-get install -y expect && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y unzip

RUN \
    apt-get install -y apt-utils && \
    apt-get install -y texinfo

# --------------------------------------------------------------------------------------------------
# Text editor
# --------------------------------------------------------------------------------------------------
RUN apt-get install -y emacs24

# --------------------------------------------------------------------------------------------------
# Python 2.x (base)
# --------------------------------------------------------------------------------------------------
RUN \
    apt-get install -y python2.7 && \
    apt-get install -y python-pip && \
    pip install --upgrade pip

# --------------------------------------------------------------------------------------------------
# Sphinx doc for Python
# --------------------------------------------------------------------------------------------------
RUN \
    apt-get install -y python-sphinx && \
    pip install -U Sphinx && \
    pip install -U ablog && \
    pip install sphinx-argparse

# --------------------------------------------------------------------------------------------------
# Configuration management
# --------------------------------------------------------------------------------------------------
RUN \
    apt-get install -y git && \
    apt-get install -y gitk && \
    pip install gitpython

# --------------------------------------------------------------------------------------------------
# Oh-my-zsh (facultative, used during update/debug of container)
# --------------------------------------------------------------------------------------------------
RUN \
    apt-get install -y zsh && \
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash

# --------------------------------------------------------------------------------------------------
# Set environment variables
# --------------------------------------------------------------------------------------------------
ENV HOME /root

# --------------------------------------------------------------------------------------------------
# Install Zlib
# --------------------------------------------------------------------------------------------------
RUN apt-get install -y zlib1g-dev

# --------------------------------------------------------------------------------------------------
# Install GTKWave (waveform viewer)
# --------------------------------------------------------------------------------------------------
RUN apt-get install -y gtkwave

# --------------------------------------------------------------------------------------------------
# STEP 1: Install GNAT 2016
# --------------------------------------------------------------------------------------------------
# Create folder + Upload .tar.gz of GNAT
RUN mkdir -p /root/tools/gnat
# Unzip
WORKDIR /root/tools/gnat
RUN wget http://mirrors.cdn.adacore.com/art/5739cefdc7a447658e0b016b
RUN mv 5739cefdc7a447658e0b016b gnat-gpl-2016-x86_64-linux-bin.tar.gz

RUN \
    tar -zxvf gnat-gpl-2016-x86_64-linux-bin.tar.gz && \
    \rm gnat-gpl-2016-x86_64-linux-bin.tar.gz

COPY src/gnat_install.expect /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin
# Install
WORKDIR /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin
RUN \
    chmod +x /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin/gnat_install.expect && \
    sync
RUN expect gnat_install.expect
ENV PATH /usr/gnat/bin:$PATH
# Valid that installation is fine
RUN which gnat

