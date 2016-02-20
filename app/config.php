<?php

// Global variables + SMTP init
define('PATH', '/celine.kiwi/app/');
define('EMAIL', 'celine.may@gmail.com');
define('IMAGES_PATH', PATH . 'assets/images/');
define('VIDEOS_PATH', PATH . 'assets/videos/');


// Errors display
error_reporting(E_ALL);
ini_set('display_errors', 'on');

// Assets
$assets = array();

$js_path = PATH.'assets/js/';
$css_path = PATH.'assets/css/';
$assets['javascripts'] = array();
$assets['stylesheets'] = array(
  $css_path . 'vendor/normalize.css',
  $css_path . 'application.css',
);
