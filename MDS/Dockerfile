FROM php:7.4-apache

# Install requirements
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libzip-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libmemcached-dev \
    zlib1g-dev \
    libpq-dev \
    default-mysql-client \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql pdo_pgsql mysqli intl zip curl opcache bcmath
RUN pecl install memcached apcu && docker-php-ext-enable memcached apcu

# Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Enable Apache modules
RUN a2enmod rewrite headers unique_id


# Set working directories
RUN mkdir -p /opt/codeigniter /opt/rr3

# Install CodeIgniter
RUN curl -L https://github.com/bcit-ci/CodeIgniter/archive/3.1.5.zip -o ci.zip \
    && unzip ci.zip \
    && mv CodeIgniter-3.1.5/* /opt/codeigniter/ \
    && rm -rf CodeIgniter-3.1.5 ci.zip

# Clone JAGGER
RUN git clone https://github.com/Edugate/Jagger /opt/rr3

# Set Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT=/opt/rr3
RUN sed -i "s|/var/www/html|/opt/rr3|g" /etc/apache2/sites-available/000-default.conf

# Copy Apache config
COPY jagger.conf /etc/apache2/sites-enabled/000-default.conf

# Install dependencies via Composer
WORKDIR /opt/rr3/application
RUN composer install

# Set index.php
COPY index.php /opt/rr3/index.php

# Copy config templates
COPY /conf/*.php /opt/rr3/application/config

# Permissions
RUN mkdir -p /opt/rr3/application/cache /opt/rr3/application/models/Proxies \
    && chown -R www-data:www-data /opt/rr3 \
    && chown -R www-data:www-data /opt/rr3/application/config \
    && chmod -R 755 /opt/rr3/application/config

RUN chown -R www-data:www-data /opt/rr3 /opt/codeigniter \
    && chmod -R 755 /opt/rr3 /opt/codeigniter \
    && chmod -R 775 /opt/rr3/application/cache /opt/rr3/application/models/Proxies /opt/rr3/application/logs /opt/rr3/application/system


# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]