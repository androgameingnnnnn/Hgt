# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set the working directory
WORKDIR /home/coder/project

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y curl

# Install Node.js (required for Pterodactyl)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Install Pterodactyl dependencies
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
        php8.0 php8.0-cli php8.0-fpm php8.0-json php8.0-common php8.0-mysql php8.0-zip \
        php8.0-gd php8.0-mbstring php8.0-curl php8.0-xml php8.0-bcmath php8.0-json \
        php8.0-openssl php8.0-zip php8.0-mysql php8.0-gd php8.0-fpm unzip git tar

# Install Composer (PHP dependency manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clone Pterodactyl repository
RUN git clone https://github.com/pterodactyl/panel.git .

# Install Pterodactyl dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Expose ports for Pterodactyl
EXPOSE 80
EXPOSE 443

# Start Pterodactyl
CMD php8.0 artisan serve --host=0.0.0.0 --port=80
