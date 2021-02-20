FROM ubuntu:20.04

RUN apt-get -qq update && apt-get -qq upgrade

ENV NGINX_VERSION nginx-1.19.3
ENV FFMPEG_VERSION snapshot
ENV NGINX_RTMP_MODULE_VERSION 1.2.1

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

ENV LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get -qq install git wget tclsh pkg-config cmake libssl-dev build-essential librtmp-dev yasm ca-certificates openssl libpcre3-dev

# Install libsrt.
RUN git clone https://github.com/Haivision/srt /tmp/build/srt

WORKDIR /tmp/build/srt
RUN ./configure
RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN make install
WORKDIR /

# Install ffmpeg.
RUN mkdir -p /tmp/build/ffmpeg && \
    cd /tmp/build/ffmpeg && \
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2

WORKDIR /tmp/build/ffmpeg/ffmpeg
RUN ./configure --enable-libsrt --enable-librtmp
RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN make install
WORKDIR /

# Install nginx.
RUN mkdir -p /tmp/build/nginx && \
    cd /tmp/build/nginx && \
    wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxf ${NGINX_VERSION}.tar.gz

# Download and decompress RTMP module
RUN mkdir -p /tmp/build/nginx-rtmp-module && \
    cd /tmp/build/nginx-rtmp-module && \
    wget -O nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    tar -zxf nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}.tar.gz && \
    cd nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION}

WORKDIR /tmp/build/nginx/${NGINX_VERSION}
RUN ./configure \
    --sbin-path=/usr/local/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx/nginx.pid \
    --lock-path=/var/lock/nginx/nginx.lock \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/tmp/nginx-client-body \
    --with-http_ssl_module \
    --with-threads \
    --with-ipv6 \
    --add-module=/tmp/build/nginx-rtmp-module/nginx-rtmp-module-${NGINX_RTMP_MODULE_VERSION} \
    --with-cc-opt="-Wimplicit-fallthrough=0" \
    --with-debug
RUN make -j $(getconf _NPROCESSORS_ONLN)
RUN make install
WORKDIR /

RUN mkdir /var/lock/nginx
RUN rm -rf /tmp/build

# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/rtmp.info.log

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 1935

CMD ["nginx", "-g", "daemon off;"]