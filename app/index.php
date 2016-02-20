<?php

include('config.php');

/* Request */
$q = isset($_GET['q']) ? explode('/', $_GET['q']) : array();
$controller = isset($q[0]) ? $q[0] : 'home';
$view = isset($q[1]) ? $q[1] : '';

include('controllers/' . $controller . 'Controller.php');

?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title><?php echo $pageTitle; ?></title>
  <meta name="description" content="<?php echo $pageDescription; ?>">

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
    App.controller = "<?php echo $controller; ?>";
  </script>
</head>

<body class="<?php echo $controller; ?>">

  <?php include_once('assets/svgs/svg-defs.svg'); ?>

  <main class="main">
    <?php
      if (is_file("views/$controller.php")) include("views/$controller.php");
      if (is_file("views/$controller/$view.php")) include("views/$controller/$view.php");
    ?>
  </main>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path ?>"></script>
  <?php endforeach; ?>
</body>
</html>
