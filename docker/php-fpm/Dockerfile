FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
    zlib1g-dev 

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql zip
ADD symfony.ini /usr/local/etc/php/conf.d/

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Guatemala /etc/localtime
RUN "date"

# install xdebug
# RUN pecl install xdebug
# RUN docker-php-ext-enable xdebug
# RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www/symfony