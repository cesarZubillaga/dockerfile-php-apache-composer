FROM php:7.1.19-stretch
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ && apt-get install -y git zip && docker-php-ext-install zip
RUN apt-get install -y libpng-dev
RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory-limit.ini" \
 && echo "date.timezone 'UTC'" > "$PHP_INI_DIR/conf.d/date_timezone.ini"  \
 && a2enmod rewrite
RUN docker-php-ext-install gd
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.6.5

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
 && php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/* /tmp/.htaccess

 CMD "composer"