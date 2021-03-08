FROM alpine:latest as build
RUN apk update &&\
    apk upgrade &&\ 
    apk add --no-cache linux-headers alpine-sdk cmake tcl openssl-dev zlib-dev musl-dev
WORKDIR /tmp
RUN git clone https://github.com/BELABOX/srt.git
RUN git clone https://github.com/muxfd/srtla.git
WORKDIR /tmp/srt
RUN ./configure && make -j $(getconf _NPROCESSORS_ONLN) && make install
WORKDIR /tmp/srtla
RUN make -j $(getconf _NPROCESSORS_ONLN)

FROM alpine:latest
ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib64
COPY --from=build /usr/local/bin/srt-* /usr/local/bin/
COPY --from=build /usr/local/lib64/libsrt* /usr/local/lib64/
COPY --from=build /tmp/srtla/srtla_rec /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/srtla_rec" ]