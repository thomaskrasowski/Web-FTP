FROM php:7-apache

MAINTAINER Thomas Krasowski <thomas@citrustelecom.com>

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
  && apt-get install -y net-tools nano vim git wget openssh-server rsyslog \
        libapache2-mod-rpaf \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libc-client-dev \
        libkrb5-dev
#        && rm -r /var/lib/apt/lists/*
RUN pecl install redis


RUN docker-php-ext-install -j$(nproc) iconv mysqli calendar  mysql  shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-enable redis

RUN a2enmod rewrite
RUN a2enmod ssl
#RUN usermod -aG users www-data
#RUN usermod -aG root www-data

#install PDF creator wkhtmltopdf with dependencies
#RUN apt-get install -y xvfb xfonts-75dpi xfonts-base libxrender1 fontconfig
#RUN cd /opt/ && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
#    ; tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
#    ; cp ./wkhtmltox/bin/wkhtmltoimage /usr/bin/ \
#    ; cp ./wkhtmltox/bin/wkhtmltopdf /usr/bin/ \
#    ; rm -rf /opt/* \
#    ; rm -r /var/lib/apt/lists/*

#copy the config files for apache2-debian
#COPY ./config/apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#COPY ./config/apache2/default-ssl.conf /etc/apache2/sites-anabled/default-ssl.conf
#COPY ./config/apache2/apache2.conf /etc/apache2/apache2.conf
COPY ./config/php.ini /usr/local/etc/php/

#copy the code
COPY ./* /var/www/html/
RUN chmod -R 777 *


#variable to change the document root folder
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
ENV APACHE_LOG_DIR /var/log/apache2/

#apache status config
RUN sed -i 's/Require\ local/Allow\ from\ all/' /etc/apache2/mods-enabled/status.conf

EXPOSE 80
EXPOSE 443


CMD apache2-foreground
