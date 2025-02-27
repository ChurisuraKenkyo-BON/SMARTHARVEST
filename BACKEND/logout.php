<?php
session_start(); 
session_unset(); 
session_destroy(); 
header("Location: ../VIEWS/log_in.html");
exit();
?>