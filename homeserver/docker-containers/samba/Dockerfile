# https://wiki.alpinelinux.org/wiki/Setting_up_a_Samba_server
# https://github.com/alubbock/samba-docker/blob/master/README.md

FROM alpine

RUN apk add --update \
    bash \
    samba-common-tools \
    samba-client \
    samba-server \
    && rm -rf /var/cache/apk/*

VOLUME ["/etc", "/var/cache/samba", "/var/lib/samba", "/var/log/samba", "/run/samba"]

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]

CMD []
