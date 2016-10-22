FROM alpine:latest

RUN ALPINE_GLIBC_VERSION="latest" && \
    ALPINE_GLIBC_REPO="sgerrand" && \
    ALPINE_GLIBC_PROJ="alpine-pkg-glibc" && \
    apk add --update -t deps wget ca-certificates curl && \
    cd /tmp && \
    wget $(curl -s https://api.github.com/repos/$ALPINE_GLIBC_REPO/$ALPINE_GLIBC_PROJ/releases/$ALPINE_GLIBC_VERSION | grep 'browser_' | egrep 'glibc-.*.apk' | cut -d\" -f4) && \
    apk add --allow-untrusted glibc-*.apk && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    apk del --purge deps glibc-i18n && \
    apk add --update ca-certificates curl wget && \
    mkdir /opt && cd /opt && \
    wget https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.linux-x64.tar.gz && \
    tar -xzf grafana-*linux-x64.tar.gz && \
    rm -rf /tmp/* /var/cache/apk/* /opt/*tar.gz && \
    mv grafana-* grafana

CMD /opt/grafana/bin/grafana-server --homepath=/opt/grafana cfg:default.paths.data=/opt/grafana/data cfg:default.paths.logs=/var/log/grafana cfg:default.paths.plugins=/opt/grafana/public/app/features/plugins web
