FROM php:8.3-apache
RUN docker-php-ext-install pdo pdo_mysql
COPY index.php /var/www/html/index.php
COPY scripts/hash_demo.php /var/www/html/scripts/hash_demo.php
EXPOSE 80
