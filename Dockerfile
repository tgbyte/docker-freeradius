FROM arm32v7/debian:8

RUN apt-get update && \
    apt-get -o Apt::Install-Recommends=0 install -y freeradius build-essential git && \
    git clone https://github.com/Yelp/dumb-init.git /dumb-init && \
    cd /dumb-init && \
    make && \
    cp dumb-init /sbin/dumb-init && \
    cd / && \
    rm -rf /dumb-init && \
    apt-get remove --purge -y build-essential git && \
    apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/freeradius/*

EXPOSE 1812/udp

VOLUME /etc/freeradius

ENTRYPOINT ["/sbin/dumb-init"]
CMD ["/usr/sbin/freeradius", "-f", "-d", "/etc/freeradius", "-X"]
