FROM golang:1.14

WORKDIR /go/src/app
COPY . .

WORKDIR /tmp
RUN git clone https://github.com/voc/srtrelay.git
RUN git clone https://github.com/BELABOX/srt.git
WORKDIR /tmp/srt
RUN ./configure && make && make install
WORKDIR /tmp/srtrelay
RUN go build

FROM alpine:latest
ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib64
RUN apk update &&\
    apk upgrade &&\
    apk add --no-cache openssl libstdc++
COPY --from=build /usr/local/bin/srt-* /usr/local/bin/
COPY --from=build /usr/local/lib64/libsrt* /usr/local/lib64/
COPY --from=build /tmp/srt-live-server/bin/* /usr/local/bin/
COPY sls.conf /etc/sls/
VOLUME /logs
EXPOSE 1935/udp
USER srt
WORKDIR /home/srt
ENTRYPOINT [ "sls", "-c", "/etc/sls/sls.conf"]