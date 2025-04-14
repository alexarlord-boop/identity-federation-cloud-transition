# Base image
FROM php:5.6-apache

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    mysql-client \
    memcached \
    libmemcached-dev \
    libmcrypt-dev \
    libapache2-mod-php \
    php5-cli \
    php5-curl \
    php5-mysql \
    php5-mcrypt \
    php-apc \
    php-memcached \
    apache2-utils \
    xmlsec1 \
    openjdk-6-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache modules
RUN a2enmod rewrite unique_id

# Set working directory
WORKDIR /usr/local/www-sites/rr3

# Clone Jagger and CodeIgniter repositories
RUN git clone https://github.com/your-jagger-repo-url.git /usr/local/www-sites/rr3
RUN git clone git://github.com/bcit-ci/CodeIgniter.git /opt/codeigniter

# Configure Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY php.ini /usr/local/etc/php/

# Set up the application
RUN chown -R www-data:www-data /usr/local/www-sites/rr3
RUN chmod -R 755 /usr/local/www-sites/rr3

# Set up MySQL database and permissions (note: assuming MySQL is running externally or you have a separate DB container)
RUN echo "CREATE DATABASE rr CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u root
RUN echo "GRANT ALL ON rr.* TO 'rr'@'localhost' IDENTIFIED BY 'rr12';" | mysql -u root
RUN echo "FLUSH PRIVILEGES;" | mysql -u root

# Run Composer install for CodeIgniter dependencies
WORKDIR /usr/local/www-sites/rr3/application
RUN /usr/local/bin/composer install

# Set up permissions for the application directory
RUN mkdir -p /usr/local/www-sites/rr3/application/models/Proxies
RUN chmod -R 755 /usr/local/www-sites/rr3/application/models/Proxies

# Expose Apache port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
