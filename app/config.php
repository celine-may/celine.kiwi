<?php

// Global variables + SMTP init
define('PATH', '/celine.kiwi/app/');
define('EMAIL', 'celine.may@gmail.com');
define('IMAGES_PATH', PATH . 'assets/images/');
define('VIDEOS_PATH', PATH . 'assets/videos/');

date_default_timezone_set('Pacific/Auckland');

// Errors display
error_reporting(E_ALL);
ini_set('display_errors', 'on');

// Assets
$assets = array();

$js_path = PATH.'assets/js/';
$css_path = PATH.'assets/css/';
$assets['javascripts'] = array(
  $js_path . 'vendor/jquery-2.2.0.min.js',
  $js_path . 'vendor/TweenMax.min.js',
  $js_path . 'vendor/TimelineMax.min.js',
  $js_path . 'vendor/CSSPlugin.min.js',
  $js_path . 'vendor/ScrollToPlugin.min.js',
  $js_path . 'vendor/modernizr-custom.min.js',
  $js_path . 'build/app.js',
  $js_path . 'build/renderer.js',
  $js_path . 'build/layout/sections.js',
  $js_path . 'build/layout/animation.js',
  $js_path . 'build/base/form.js',
  $js_path . 'build/components/slideshow.js',
  $js_path . 'build/components/pagination.js',
);
$assets['stylesheets'] = array(
  $css_path . 'vendor/normalize.css',
  $css_path . 'build/application.css',
);
