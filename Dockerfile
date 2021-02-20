FROM debian:latest AS builder

RUN apt-get update \
 && apt-get install -y build-essential git wget \
 && apt-get install -y libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev \
 && cd /root \
 && wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2 \
 && tar -xf boost_1_75_0.tar.bz2 \
 && git clone --recursive https://github.com/badaix/snapcast.git \
 && cd snapcast \
 && ADD_CFLAGS="-I/root/boost_1_75_0" make



FROM alpine:edge

RUN apk add -U avahi-libs flac libvorbis alsa-lib soxr pulseaudio opus
COPY --from=builder /root/snapcast/server/snapserver /root/snapcast/client/snapclient /usr/local/bin/

WORKDIR /data
