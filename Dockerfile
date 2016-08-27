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
MAINTAINER Rafael Catrou <rafaelcatrou@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update -y && \
    apt-get install -y apt-utils

RUN \
    apt-get upgrade -y && \
    apt-get install -y make && \
    apt-get install -y wget && \
    apt-get install -y expect

RUN mkdir -p /root/tools/gnat

WORKDIR /root/tools/gnat

# Download GNAT 2016 from AdaCore (site: http://libre.adacore.com/download/configurations#)
RUN \
    wget -q http://mirrors.cdn.adacore.com/art/5739cefdc7a447658e0b016b && \
    tar -zxvf 5739cefdc7a447658e0b016b && \
    rm -f 5739cefdc7a447658e0b016b

# Install GNAT
COPY src/gnat_install.expect /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin

WORKDIR /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin

RUN \
    chmod +x /root/tools/gnat/gnat-gpl-2016-x86_64-linux-bin/gnat_install.expect && \
    sync && \
    expect gnat_install.expect
    
ENV PATH /usr/gnat/bin:$PATH

# Valid that installation is fine
RUN which gnat

# --------------------------------------------------------------------------------------------------
# End
# --------------------------------------------------------------------------------------------------

