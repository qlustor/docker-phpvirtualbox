FROM qlustor/nginx-php-fpm
MAINTAINER Team QLUSTOR <team@qlustor.com>

# Install phpvirtualbox
ENV PHPVBOX_BUILD phpvirtualbox-5.0-4
ENV PHPVBOX_DLURL http://sourceforge.net/projects/phpvirtualbox/files/$PHPVBOX_BUILD.zip/download
RUN rm -rf /var/www/* && \
    apk --update add wget unzip && \
    wget $PHPVBOX_DLURL -O /var/$PHPVBOX_BUILD.zip && \
    unzip /var/$PHPVBOX_BUILD.zip -d /var && \
    mv /var/$PHPVBOX_BUILD/* /var/www && \
    chown -R nginx:nginx /var/www/* && \
    rm -f /var/$PHPVBOX_BUILD.zip && \
    apk del wget unzip && \
    rm -rf /var/cache/apk/*

ADD . /

EXPOSE 80 443
#VOLUME /var/www
ENTRYPOINT php /servers-from-env.php && supervisord --nodaemon --configuration="/etc/supervisord.conf"

