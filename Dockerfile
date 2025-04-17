FROM php:8.2-apache

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    git zip unzip curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    libcurl4-openssl-dev pkg-config libssl-dev libicu-dev libxslt1-dev \
    zlib1g-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install pdo_mysql soap intl bcmath zip gd xsl


# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the source code into the container
COPY . /var/www/html/

# Install PHP dependencies using Composer (if your app uses Composer)
# RUN composer install --no-dev --optimize-autoloader

# Set permissions (optional, depending on your environment)
RUN chown -R www-data:www-data /var/www/html

# Change the DocumentRoot to the public/ folder
RUN sed -i 's|/var/www/html|/var/www/html/pub|' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|/var/www/html|/var/www/html/pub|' /etc/apache2/sites-available/default-ssl.conf

# Enable Apache mod_rewrite (common for Laravel, Symfony, etc.)
RUN a2enmod rewrite

# Add a Directory block for phpserver if needed
RUN echo '<Directory /var/www/html/phpserver>\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

# Expose port 80 for Apache
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]