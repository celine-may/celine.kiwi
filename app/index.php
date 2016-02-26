<?php

include('config.php');

/* Request */
$q = isset($_GET['q']) ? explode('/', $_GET['q']) : array();
$view = isset($q[0]) ? $q[0] : 'home';

?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title>Celine Rufener | Digital Alchemist &amp; Front End Developer | Auckland, New Zealand</title>
  <meta name="description" content="I am an Auckland based front end developer with a passion for code and bringing designs to life.">

  <meta property="og:site_name" content="Celine">
  <meta property="og:type" content="Website">
  <meta property="og:url" content="http://celine.kiwi">
  <meta property="og:title" content="Celine.kiwi">
  <meta property="og:description" content="Front End Developer">
  <meta property="og:image" content="<?php echo IMAGES_PATH; ?>layout/celine-fb.jpg">

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

<body>

  <?php include_once('assets/svgs/svg-defs.svg'); ?>

  <main class="main">
    <video loop poster="<?php echo IMAGES_PATH; ?>home-bg.jpg" class="video-bg">
      <source src="<?php echo VIDEOS_PATH ?>ink.mp4" type="video/mp4">
      <source src="<?php echo VIDEOS_PATH ?>ink.webm" type="video/webm">
      <img src="<?php echo IMAGES_PATH; ?>home-bg.jpg" alt="Fallback image for the background video. Captures ink floating in water.">
    </video>

    <?php include('sections/home.php'); ?>
  </main>

  <button class="menu-btn do-show-menu">
    <span class="burger">
      <span class="burger-layer"></span>
    </span>
  </button>

  <button class="contact-link main-copy small-hidden do-show-contact">contact</button>

  <div class="overlay">
    <div class="overlay-panel top"></div>
    <div class="overlay-panel bottom"></div>
    <?php include("sections/menu.php"); ?>
    <?php include("sections/contact.php"); ?>
  </div>

  <span class="device">
    <span class="bg"></span>
  </span>

  <script type="text/javascript">
    var video = document.getElementsByTagName("video")[0];
    playVideo = function() {
      video.play();
    }
    video.addEventListener('canplay', playVideo(), true);
  </script>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path; ?>"></script>
  <?php endforeach; ?>
</body>
</html>
