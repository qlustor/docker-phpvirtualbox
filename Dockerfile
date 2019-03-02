#BUILDS qlustor/phpvirtualbox

FROM qlustor/nginx-php-fpm
MAINTAINER Team QLUSTOR <team@qlustor.com>

# Install phpvirtualbox
ENV PHPVBOX_BUILD develop
ENV PHPVBOX_DLURL https://github.com/phpvirtualbox/phpvirtualbox/archive/develop.zip
ENV PHPVBOX_FNAME phpvirtualbox-$PHPVBOX_BUILD
RUN apk-install --update ca-certificates                \
 && update-ca-certificates                              \
 && apk-install wget unzip                              \
 && wget $PHPVBOX_DLURL -O /var/$PHPVBOX_FNAME.zip      \
 && unzip /var/$PHPVBOX_FNAME.zip -d /var               \
 && mv /var/$PHPVBOX_FNAME/* /var/www                   \
 && chown -R nginx:nginx /var/www/*                     \
 && rm -f /var/$PHPVBOX_FNAME.zip                       \
 && rm -rf /var/$PHPVBOX_FNAME
ADD . /

EXPOSE 80
ENTRYPOINT php /servers-from-env.php && /sbin/runit-docker

