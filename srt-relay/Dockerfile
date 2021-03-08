FROM golang:1.16

RUN apt update &&\
    apt upgrade -y &&\ 
    apt install -y cmake tcl openssl libssl-dev

WORKDIR /tmp
RUN git clone https://github.com/voc/srtrelay.git
RUN git clone https://github.com/BELABOX/srt.git
WORKDIR /tmp/srt
RUN ./configure && make -j $(getconf _NPROCESSORS_ONLN) && make install
WORKDIR /tmp/srtrelay
RUN go build

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib
COPY config.toml /etc/srtrelay/config.toml
EXPOSE 1935/udp
ENTRYPOINT [ "/tmp/srtrelay/srtrelay" ]