# Multi-stage build for Laravel on Render (free plan compatible)
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-progress --no-interaction --prefer-dist

FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY resources resources
COPY vite.config.js ./
RUN npm run build

FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx supervisor bash icu-dev libzip-dev oniguruma-dev \
    freetype-dev libpng-dev libjpeg-turbo-dev zlib-dev libpq-dev git \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install gd intl zip pdo_mysql pdo_pgsql bcmath

WORKDIR /var/www/html
COPY . .
COPY --from=vendor /app/vendor ./vendor
COPY --from=assets /app/public/build ./public/build

RUN mkdir -p /var/www/html/storage/framework/{cache,data,sessions,views} \
 && mkdir -p /run/nginx \
 && chown -R www-data:www-data /var/www/html /run/nginx /var/log \
 && php artisan config:clear && php artisan route:clear && php artisan view:clear

COPY deploy/nginx.conf /etc/nginx/http.d/default.conf
COPY deploy/supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
