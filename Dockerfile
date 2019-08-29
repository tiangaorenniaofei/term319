FROM ubuntu
LABEL maintainer="test@163.com"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/squid/sbin \
    SQUID_VERSION=4.8 SQUID_CACHE_DIR=/usr/local/squid/var/cache \
    SQUID_LOG_DIR=/usr/local/squid/var/logs SQUID_USER=nobody SQUID_GROUP=nogroup
EXPOSE 3128/tcp
COPY install.sh \
     db-4.7.25.tar.gz \
     openldap-stable-20090411.tgz \
     squid-4.8.tar.gz \
     /usr/local/src/
RUN sh /usr/local/src/install.sh \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/local/src/* \
    && apt-get purge -y --auto-remove gcc g++ perl wget make groff
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
