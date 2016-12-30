# Pull base image.
FROM ubuntu:14.04

RUN locale-gen ko_KR.UTF-8
RUN update-locale LANG=ko_KR.UTF-8
RUN dpkg-reconfigure locales

ENV LANG ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# Install curl
RUN \
    sed -ri 's/\/archive\.ubuntu\.com/\/kr\.archive\.ubuntu\.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y ca-certificates curl python build-essential git-core && \
    rm -rf /var/lib/apt/lists/*


# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
                                                                                        
ENV NODE_VERSION 6.9.2

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& npm install -g npm \
	&& npm install -g gitbook-cli \
	&& npm install -g nodemon \
	&& npm cache clear \
	&& gitbook update \
	&& mkdir -p /work && cd /work && gitbook init

EXPOSE 4000
WORKDIR /work
CMD [ "/usr/local/bin/gitbook", "serve" ]
