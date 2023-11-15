# Wordpress

Author := `git config --get user.name`



@_default: 
  just --list --unsorted

@phpinfo:
  #!/usr/bin/php
  <?php phpinfo(); exit; ?>



#_init-wp-theme:
_create-theme-style-css:
  touch style.css
  cat << EOF >>```
  @charset "UTF-8";
  /*!
  Theme Name: {{themeName}}
  Theme URI: https://github.com/{{Author}}/{{themeName}}
  Author: {{Author}}
  Author URI: https://denyshnatiuk.github.io/
  Description: Description 
  Version: {{themeVersion}} 
  Requires PHP: {{phpVersion}}
  Tested up to: {{phpTestsVersion}}
  License: GNU General Public License v2 or later 
  License URI: LICENSE 
  Text Domain: {{themeName}}
  Tags:  
  
  This theme, like WordPress, is licensed under the GPL. 
  */ ```EOF

# backup database:
backup_database:
  mysqldump -u username -p database_name > database_name.sql

# Update WordPress
update_wordpress:
  wp core version
  wp core update
  wp plugin update --all
  wp theme update --all
  wp core version