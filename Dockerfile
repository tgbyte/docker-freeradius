FROM tgbyte/ubuntu:24.04

RUN set -x \
    && apt-get update -yy -q \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Apt::Install-Recommends=0 install -y -q \
        dumb-init \
        freeradius \
    && rm /etc/ssl/private/ssl-cert-snakeoil.* \
    && apt-get --purge -y autoremove \
    && rm -rf /var/lib/apt/lists/*

VOLUME /etc/freeradius
EXPOSE 1812/udp

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/usr/sbin/freeradius", "-f", "-d", "/etc/freeradius/3.0", "-X"]
