FROM debian:10

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
CMD ["/usr/sbin/freeradius", "-f", "-d", "/etc/freeradius/3.0", "-X"]
