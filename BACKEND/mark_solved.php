<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "smartharvest";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$id = $_GET['id'];

$sql = "UPDATE alerts SET solved = TRUE WHERE id = $id";
$conn->query($sql);

$conn->close();
?>
