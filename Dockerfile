FROM php:8.3-cli

RUN docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache
