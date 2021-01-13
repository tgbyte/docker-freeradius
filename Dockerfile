FROM amd64/ubuntu:20.04 as qemu

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && apt-get update -qq \
  && apt-get install -qq -y qemu-user-static

FROM debian:10

COPY --from=qemu /usr/bin/qemu-arm-static /usr/bin
COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin

RUN set -x \
    && apt-get update \
    && apt-get -o Apt::Install-Recommends=0 install -y \
        dumb-init \
        freeradius \
    && apt-get --purge -y autoremove \
    && rm -rf /var/lib/apt/lists/*

VOLUME /etc/freeradius
EXPOSE 1812/udp

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/usr/sbin/freeradius" "-f" "-d" "/etc/freeradius" "-X"]
