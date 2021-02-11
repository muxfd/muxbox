#!/bin/bash

# Clone repository
apt -qq update
apt -qq install git

git clone https://github.com/muxfd/muxbox

cd muxbox

# Install Docker
apt -qq install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt -qq update
apt -qq install docker-ce docker-ce-cli containerd.io

# Install docker-compose
curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install speedify
wget -qO- https://get.speedify.com | bash -

/usr/share/speedify/speedify_cli login
/usr/share/speedify/speedify_cli connect
/usr/share/speedify/speedify_cli startupconnect on

cp speedify.conf /etc/speedify/speedify.conf

service speedify-sharing restart

# Configure iptables
apt -qq install iptables-persistent

iptables -t mangle -I POSTROUTING -j TTL --ttl-set 65
iptables -t mangle -I PREROUTING -j TTL --ttl-set 65
ip6tables -t mangle -A POSTROUTING -j HL --hl-set 65
ip6tables -t mangle -I PREROUTING -j HL --hl-set 65
