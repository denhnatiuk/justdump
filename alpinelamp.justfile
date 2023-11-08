#!/usr/bin/env just --justfile

set shell := ["zsh", "-cu"] 
set dotenv-load := true
set positional-arguments := true

JUSTFILE_VERSION := "1.0.0"

TIMEZONE := America/Santiago

#start_server:
@start_server:
  just apache_start
  just mysql_check_dir_and_install_db
  just mysql_check_credentials
  just mysql_use_random_pass
  just mysql_config_user
  just mysql_start

# start apache
@apache_start:
  #!/bin/sh
#  #!/usr/bin/env bash
  set -euo pipefail

  echo "Starting httpd"
  httpd
  echo "Done httpd"


# check if mysql data directory is nuked and if so, install the db
@mysql_check_dir_and_install_db:
  echo "Checking /var/lib/mysql folder"
  if [ ! -f /var/lib/mysql/ibdata1 ]; then 
      echo "Installing db"
      mariadb-install-db --user=mysql --ldata=/var/lib/mysql > /dev/null
      echo "Installed"
  fi;

# from mysql official docker repo
@mysql_check_credentials:
if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_RANDOM_ROOT_PASSWORD'
			exit 1
fi

# random password
@mysql_use_random_pass:
  if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
      echo "Using random password"
      MYSQL_ROOT_PASSWORD="$(pwgen -1 32)"
      echo "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
      echo "Done"
  fi

@mysql_config_user:
  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
      USE mysql;
      DELETE FROM user;
      FLUSH PRIVILEGES;
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
      UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
      FLUSH PRIVILEGES;
  EOF

  echo "Querying user"
  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile
  echo "Done query"

# start mysql
@mysql_start:
# nohup mysqld_safe --skip-grant-tables --bind-address 0.0.0.0 --user mysql > /dev/null 2>&1 &
  echo "Starting mariadb database"
  exec /usr/bin/mysqld --user=root --bind-address=0.0.0.0

@software_install:
  apt update && apt upgrade -y
  apt install mariadb mariadb-client \
    apache2 \
    apache2-utils \
    curl wget \
    tzdata \
    php7-apache2 \
    php7-cli \
    php7-phar \
    php7-zlib \
    php7-zip \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-json \
    php7-mcrypt \
    php7-xml \
    php7-dom \
    php7-iconv \
    php7-xdebug \
    php7-session \
    php7-intl \
    php7-gd \
    php7-mbstring \
    php7-apcu \
    php7-opcache \
    php7-tokenizer \
    php7-simplexml
