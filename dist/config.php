<?php

// Global variables + SMTP init
define('PATH', '/');
define('EMAIL', 'celine.may@gmail.com');
define('IMAGES_PATH', PATH . 'assets/images/');
define('VIDEOS_PATH', PATH . 'assets/videos/');


// Errors display
error_reporting(E_ALL);
ini_set('display_errors', 'on');

// Assets
$assets = array();

$js_path = PATH.'assets/javascripts/';
$css_path = PATH.'assets/stylesheets/';
$assets['javascripts'] = array();
$assets['stylesheets'] = array(
  $css_path . 'application.min.css',
);
