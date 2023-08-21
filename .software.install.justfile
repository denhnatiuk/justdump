
#install 

test-existance *args:
  type -p $1 > /dev/null || echo "$1 not found"

apt_install *args:
  just apt_update
  sudo apt-get install $1

upd:
  just apt_update
  just brew_update

apt_update:
  sudo apt update 
  sudo apt upgrade -y 
  sudo apt autoremove

brew_update:
  brew update 
  brew outdated 
  brew upgrade

install-wp-cli:
  #!/usr/bin/env shell
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  php wp-cli.phar --info
  chmod +x wp-cli.phar
  sudo mv wp-cli.phar /usr/local/bin/wp
  wp --info
# https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/utils/wp-completion.bash

install-composer:
  #!/usr/bin/env bash
  if ! [ -x "$(command -v composer)" ]; then 
    echo 'Installing Composer'
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc

    else composer --version
  fi

install-dart:
  just apt_install apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  just apt_install dart
  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile


install-gh:
  type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg 
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
  sudo apt update 
  sudo apt install gh -y

# arguments: 1.app 2.dependencies 3.repo_url 4.key_url
ubuntu-install-app *args='':
  just apt_update
  sudo apt-get install $2

  wget -qO- $4 | sudo gpg --dearmor -o `/usr/share/keyrings/`$1`.gpg`
  echo `deb [signed-by=/usr/share/keyrings/`$1`.gpg arch=amd64] `$3` stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list`

  sudo apt-update
  sudo apt-get install $1

  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile

# if [ $EXIT_CODE -eq 124 ]; then \
#   echo "Timed out"; \
#   exit $EXIT_CODE; \
# fi

# Install Google Chrome
install-chrome:
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > chrome.gpg
  sudo install -o root -g root -m 644 chrome.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt update
  sudo apt install google-chrome-stable

# Install MS Edge
install-edge:
  sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/edge/ stable main" >> /etc/apt/sources.list.d/microsoft_edge.list'
  sudo apt update
  sudo apt install microsoft-edge-stable


# install-composer:
#   if ! [ -x "$(command -v composer)" ]; then \
#     echo 'Error: composer is not installed.' >&2 \
#     exit 1 \
#   else \
# # sudo apt-get install git \
#   fi

install-php-tools:
  composer require --dev "composer/installers"
  composer require --dev "wpreadme2markdown/wpreadme2markdown"
# composer global require "phpunit/phpunit"
# composer global require "phpunit/dbunit"
# composer global require "phing/phing"
# composer global require "phpdocumentor/phpdocumentor"
# composer global require "phploc/phploc"
# composer global require "phpmd/phpmd"

# php static analysis tool with rules set
  composer require --dev "phpstan/phpstan"
  composer require --dev "phpstan/phpstan-strict-rules"
  composer require --dev "php-stubs/wp-cli-stubs"
  composer require --dev "szepeviktor/phpstan-wordpress"
  composer require --dev "phpstan/extension-installer"

# php code sniffer tool with rules set
  composer require --dev "squizlabs/php_codesniffer"
  composer require --dev "phpcompatibility/php-compatibility"
  composer require --dev "wp-coding-standards/wpcs"
  composer require --dev "dealerdirect/phpcodesniffer-composer-installer"

  composer global update

  echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.path_extenddings

  phpcs --config-set installed_paths %APPDATA%\Composer\vendor\wp-coding-standards\wpcs
  phpcs -i
