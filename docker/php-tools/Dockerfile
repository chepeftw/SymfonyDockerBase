FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
	zlib1g-dev \
    git \
    unzip

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
	chmod a+x /usr/local/bin/symfony
RUN symfony --version

WORKDIR /var/www/symfony