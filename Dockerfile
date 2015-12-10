FROM alpine:3.2
MAINTAINER Leigh Phillips <neurocis@qlustor.com>

# Install supervisord
RUN apk --update add supervisor && \
    rm -rf /var/cache/apk/*

# Install nginx-php-fpm
RUN apk --update add nginx php-fpm php-cli && \
#    sed -i \
#        -e 's/group =.*/group = nginx/' \
#        -e 's/user =.*/user = nginx/' \
#        -e 's/listen\.owner.*/listen\.owner = nginx/' \
#        -e 's/listen\.group.*/listen\.group = nginx/' \
#        -e 's/error_log =.*/error_log = \/dev\/stdout/' \
#        /etc/php/php-fpm.conf && \
#    sed -i \
#        -e '/open_basedir =/s/^/\;/' \
#        /etc/php/php.ini && \
    rm -rf /var/www/* && \
    rm -rf /var/cache/apk/*

# Install phpvirtualbox
ENV PHPVBOX_BUILD phpvirtualbox-5.0-4
ENV PHPVBOX_DLURL http://sourceforge.net/projects/phpvirtualbox/files/$PHPVBOX_BUILD.zip/download
RUN apk --update add wget unzip && \
    wget $PHPVBOX_DLURL -O /var/$PHPVBOX_BUILD.zip && \
    unzip /var/$PHPVBOX_BUILD.zip -d /var && \
    mv /var/$PHPVBOX_BUILD/* /var/www && \
    rm -f /var/$PHPVBOX_BUILD.zip && \
    apk del wget unzip && \
    rm -rf /var/cache/apk/*

ADD . /

EXPOSE 80 #443
#VOLUME /var/www
ENTRYPOINT php /servers-from-env.php && supervisord --nodaemon --configuration="/etc/supervisord.conf"

