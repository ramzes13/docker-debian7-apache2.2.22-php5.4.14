FROM debian:7.11

MAINTAINER ramzes13 <petru.darii@gmail.com>

RUN echo "deb-src http://ftp.debian.org/debian wheezy main contrib non-free" >> /etc/apt/sources.list

RUN  apt-get update && yes | apt-get install curl wget nano mc build-essential checkinstall zip adduser

RUN wget -qO - http://docs.mongodb.org/10gen-gpg-key.asc?_ga=1.75751317.1477152093.1472380371 | apt-key add - \
	&& echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list \
	&& apt-get update

RUN yes | apt-get install apache2 apache2-doc apache2-utils

RUN yes | apt-get build-dep php5

RUN yes | apt-get -y install libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev

RUN mkdir -p /opt/php/5.4.14 \
	&& mkdir /usr/local/src/php5-build \
	&& cd /usr/local/src/php5-build \
	&& wget http://museum.php.net/php5/php-5.4.14.tar.gz \
	&& tar -xzvf php-5.4.14.tar.gz \
	&& cd php-5.4.14 \
	&& ./configure \
	&& make \
	&& make install
	&& apt-get install -y php5 libapache2-mod-php5  \
    php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite \
    php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

