ARG VERSION=8.3
FROM php:${VERSION}-cli

RUN docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache
