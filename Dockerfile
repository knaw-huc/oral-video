FROM php:7.4-apache
COPY php-apache/config/php.ini  /usr/local/etc/php/php.ini
RUN apt-get update && apt-get install -y libc-client-dev libfreetype6-dev libmcrypt-dev libpng-dev libjpeg-dev libldap2-dev zlib1g-dev libkrb5-dev libtidy-dev libzip-dev libsodium-dev libpq-dev libxml2-dev libxslt1-dev  && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd mysqli pdo pdo_mysql pdo_pgsql opcache zip iconv tidy xml xsl \
    && docker-php-ext-configure ldap --with-libdir=lib/$(gcc -dumpmachine)/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-install sodium \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install exif

RUN apt-get update && apt-get install -y curl vim mariadb-client python3 python3-pip
# RUN pip3 install mysql-connector
# COPY profiles/profile.xml /var/www/html/ccf/data/profiles/profile.xml
# COPY profiles/profileTweak.xml /var/www/html/ccf/data/tweaks/profileTweak.xml
# WORKDIR /var/html/

ENV DB_SERVER mysql
ENV DB_USER root
ENV DB_PASSWD rood
ENV DB_NAME soundfiles
ENV BASE_URL "http://localhost/"
# RUN htpasswd -b -c /var/www/htp test test

# COPY html /var/www/html

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && a2enmod rewrite && a2enmod headers && service apache2 restart
