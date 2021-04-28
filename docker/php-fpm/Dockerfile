# Image
FROM php:7.4-fpm

# Starting from scratch
RUN apt-get clean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update dependencies
RUN apt-get update

# Zip
RUN apt-get install -y libzip-dev zip && docker-php-ext-configure zip && docker-php-ext-install zip

# Curl
RUN apt-get install -y libcurl3-dev curl && docker-php-ext-install curl

# BC Math
RUN docker-php-ext-install bcmath

# PostgreSQL
RUN apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

# Human Language and Character Encoding Support
RUN apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

# Install GD
# RUN apt-get install -y libpng-dev \
#     libfreetype6-dev \
#     libwebp-dev \
#     libjpeg62-turbo-dev \
#     nano \
#     libgmp-dev

# RUN docker-php-ext-configure gd --with-jpeg \
#     && docker-php-ext-install gd

RUN apt-get install -y \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev libxpm-dev \
    libfreetype6-dev

RUN docker-php-ext-configure gd \
    --with-webp \
    --with-jpeg \
    --with-xpm \
    --with-freetype

RUN docker-php-ext-install gd

# Custom php.ini config
COPY php.ini /usr/local/etc/php/php.ini

# Install Xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Clean up
RUN apt-get clean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up default directory
WORKDIR /var/www/api
