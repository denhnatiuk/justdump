
#install 

test-existance *args:
  type -p $1 > /dev/null || echo "$1 not found"

install *args:
  echo " "


install-dart:
  sudo apt-get update
  sudo apt-get install apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt-get update
  sudo apt-get install dart
  echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile


install-gh:
  type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg 
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null 
  sudo apt update 
  sudo apt install gh -y