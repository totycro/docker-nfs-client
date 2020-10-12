FROM alpine:3.12.0

RUN apk update && \
    apk add --update nfs-utils tini &&  \
    rm -rf /var/cache/apk/*

ENV FSTYPE nfs4
ENV MOUNT_OPTIONS ""
ENV MOUNT_POINT "/nfs"
ENV MOUNT_TARGET ""

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["tini", "-g", "--", "/usr/local/bin/entrypoint.sh"]
