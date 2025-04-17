FROM gitpod/workspace-full

RUN sudo add-apt-repository ppa:ondrej/php -y && \
    sudo apt update && \
    sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-curl \
    php8.2-mysql php8.2-bcmath php8.2-soap php8.2-zip php8.2-intl \
    php8.2-gd php8.2-xsl unzip php8.2-dom php8.2-mbstring

RUN curl -sS https://getcomposer.org/installer | php && \
    sudo mv composer.phar /usr/local/bin/composer