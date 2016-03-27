<?php

include('config.php');

/* Request */
$q = isset($_GET['q']) ? explode('/', $_GET['q']) : array();
$view = isset($q[0]) ? $q[0] : 'home';

?><!DOCTYPE html>
<html lang="en" class="no-js">
<head>
  <meta charset="utf-8">

  <title>Celine Rufener | Digital Alchemist &amp; Front End Developer | Auckland, New Zealand</title>
  <meta name="description" content="I am an Auckland based front end developer with a passion for code and bringing designs to life.">

  <meta property="og:site_name" content="Celine.kiwi">
  <meta property="og:type" content="Website">
  <meta property="og:url" content="http://celine.kiwi">
  <meta property="og:title" content="Celine Rufener | Digital Alchemist &amp; Front End Developer">
  <meta property="og:description" content="I am an Auckland based front end developer with a passion for code and bringing designs to life.">
  <meta property="og:image" content="http://www.celine.kiwi/assets/images/celine-fb.png">
  <meta property="fb:app_id" content="1520512718258604">

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">

  <link rel="icon" href="<?php echo IMAGES_PATH; ?>/layout/favicon.ico" type="image/x-icon"/>

  <?php foreach ($assets['stylesheets'] as $file_path) : ?>
    <link rel="stylesheet" href="<?php echo $file_path ?>">
  <?php endforeach ?>

  <script>
    window.App = {};
    App.path = "<?php echo PATH; ?>";
    App.FXs = [];
  </script>
</head>

<body data-section="home">

  <?php include_once('assets/svgs/svg-defs.svg'); ?>

  <div class="video-fallback inverse"></div>
  <div class="video-fallback normal"></div>

  <main class="main">
    <video autoplay loop class="video-bg normal">
      <source src="<?php echo VIDEOS_PATH ?>ink.mp4" type="video/mp4">
      <source src="<?php echo VIDEOS_PATH ?>ink.webm" type="video/webm">
      <img src="<?php echo IMAGES_PATH; ?>video-fallback.jpg" alt="Fallback image for the background video. Captures ink floating in water.">
    </video>

    <video autoplay loop class="video-bg inverse">
      <source src="<?php echo VIDEOS_PATH ?>ink-inverse.mp4" type="video/mp4">
      <source src="<?php echo VIDEOS_PATH ?>ink-inverse.webm" type="video/webm">
      <img src="<?php echo IMAGES_PATH; ?>video-inverse-fallback.jpg" alt="Fallback image for the background video. Captures ink floating in water.">
    </video>

    <?php include('sections/home.php'); ?>
    <?php include('sections/about.php'); ?>
    <?php include('sections/work.php'); ?>
    <?php include('sections/skills.php'); ?>
  </main>

  <button class="menu-btn ui do-show-overlay" data-overlay="menu">
    <span class="burger">
      <span class="burger-layer"></span>
    </span>
  </button>

  <button class="contact-link ui main-copy small-hidden do-show-overlay" data-overlay="contact">contact</button>

  <div class="overlay">
    <div class="overlay-panel top"></div>
    <div class="overlay-panel bottom"></div>
    <?php include("sections/menu.php"); ?>
    <?php include("sections/contact.php"); ?>
  </div>

  <div class="device-container touch-hidden small-hidden">
    <div class="device-wrapper">
      <div class="device-border left"></div>
      <div class="device-border right"></div>
      <div class="device"></div>
    </div>
  </div>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path; ?>"></script>
  <?php endforeach; ?>
</body>
</html>
