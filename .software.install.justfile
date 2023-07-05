
#install 

test-existance *args:
  type -p $1 > /dev/null || echo "$1 not found"

apt_install *args:
  just apt_upgrade
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