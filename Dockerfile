FROM php:8.2-cli

RUN docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache
