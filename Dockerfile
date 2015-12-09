FROM qlustor/nginx-php-fpm
MAINTAINER Leigh Phillips <neurocis@qlustor.com>

ENV PHPVBOX_BUILD phpvirtualbox-5.0-4
ENV PHPVBOX_DLURL http://sourceforge.net/projects/phpvirtualbox/files/$PHPVBOX_BUILD.zip/download
#ENV PHPVBOX_DLURL http://www.mirrorservice.org/sites/downloads.sourceforge.net/p/ph/phpvirtualbox/$PHPVBOX_BUILD.zip

# install phpvirtualbox
RUN apk --update add wget unzip && \
    wget $PHPVBOX_DLURL -O /var/$PHPVBOX_BUILD.zip && \
    unzip /var/$PHPVBOX_BUILD.zip -d /var && \
    mv /var/$PHPVBOX_BUILD/* /var/www && \
    rm -f /var/$PHPVBOX_BUILD.zip && \
    echo "<?php return array(); ?>" > /var/www/config-servers.php && \
    echo "<?php phpinfo(); ?>" > /var/www/phpinfo.php && \
    chown -R nginx:nginx /var/www && \
    apk del wget unzip && \
    rm -rf /var/cache/apk/*

# add nginx configuration
ADD nginx.conf /docker/config/nginx.conf

# add server config with linked instances enhancement
ADD config.php /var/www/config.php

# add startup script to write linked instances to server config
ADD servers-from-env.php /docker/servers-from-env.php

# expose only nginx HTTP port
EXPOSE 80

# write linked instances to config, then monitor all services
ENTRYPOINT php /docker/servers-from-env.php && /docker/entrypoint.sh nginx-php-fpm

