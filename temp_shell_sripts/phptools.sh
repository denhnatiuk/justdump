#!/usr/bin/env zsh
tools=( \
  "composer/installers" \
  "wpreadme2markdown/wpreadme2markdown" \
# php static analysis tool with rules set
  "phpstan/phpstan" \
  "phpstan/phpstan-strict-rules" \
  "php-stubs/wp-cli-stubs" \
  "szepeviktor/phpstan-wordpress" \
  "phpstan/extension-installer" \
# php code sniffer tool with rules set
  "squizlabs/php_codesniffer" \
  "phpcompatibility/php-compatibility" \
  "wp-coding-standards/wpcs" \
  "dealerdirect/phpcodesniffer-composer-installer" \
)
for i in "${tools[@]}"
do
  composer search "$i"
done
