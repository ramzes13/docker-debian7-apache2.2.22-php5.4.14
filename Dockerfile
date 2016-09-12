FROM nimmis/debian:wheezy

MAINTAINER ramzes13 <petru.darii@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && yes | apt-get install curl wget nano mc build-essential checkinstall zip adduser

RUN yes | apt-get install php5 libapache2-mod-php5 \
          php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite \
          php5-intl php5-imagick php5-mcrypt php5-gd php5-curl

RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN wget --no-check-certificate -qO - http://docs.mongodb.org/10gen-gpg-key.asc?_ga=1.10989044.1320971647.1473661782 | apt-key add -

RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

RUN apt-get update && apt-get install mongodb-10gen=2.4.6

RUN yes | apt-get install php5-dev \
    && yes | apt-get install php-pear  \
    && yes | apt-get install libcurl3-openssl-dev

# decline to install ssl connection to mongo
RUN no | pecl install mongo \
    && echo "extension=$(find /usr/lib/php5/ -name mongo.so)" >> /etc/php5/apache2/php.ini \
    && echo "extension=$(find /usr/lib/php5/ -name mongo.so)" >> /etc/php5/cli/php.ini

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_enable=1" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_mode=req" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_port=9000" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.max_nesting_level=300" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php5/apache2/php.ini \
    && echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_enable=1" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_mode=req" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_port=9000" >> /etc/php5/cli/php.ini \
    && echo "xdebug.max_nesting_level=300" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php5/cli/php.ini