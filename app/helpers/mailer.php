<?php

include('../config.php');
include('../helpers/PHPMailer/PHPMailerAutoload.php');

// Get data
$name = isset($_POST['name']) ? strip_tags($_POST['name']) : '';
$email = isset($_POST['email']) ? strip_tags($_POST['email']) : '';
$message = isset($_POST['message']) ? strip_tags($_POST['message']) : '';

// Build html content and send e-mail
$html_content = "Name: $name<br>";
$html_content .= "Email: $email<br><br>";
$html_content .= "Message:<br><br>" . nl2br($message);

$mail = new PHPMailer;
$mail->isSMTP();
$mail->isSendmail();
$mail->setFrom('no-reply@celine.kiwi');
$mail->addReplyTo($email, $name);
$mail->addAddress(EMAIL);
$mail->Subject = 'Contact request from celine.kiwi';
$mail->msgHTML($html_content);
$mail->AltBody = strip_tags($html_content);

if (!$mail->send())
  echo 'Error: ' . $mail->ErrorInfo;
else
  echo 'success';
