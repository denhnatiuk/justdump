# Wordpress
_init-wp-theme:


_create-theme-style-css:
  touch style.css
  cat << EOF >>```
  @charset "UTF-8";
  /*!
  Theme Name: geliostrans
  Theme URI: https://github.com/DenysHnatiuk/cv/
  Author: Den Hnatiuk  
  Author URI: https://denyshnatiuk.github.io/geliostrans/ 
  Description: Description 
  Version: 0.0.1 
  Requires PHP: 5.6 
  Tested up to: 5.4 
  License: GNU General Public License v2 or later 
  License URI: LICENSE 
  Text Domain: geliostrans 
  Tags:  
  
  This theme, like WordPress, is licensed under the GPL. 
  */ ```EOF
