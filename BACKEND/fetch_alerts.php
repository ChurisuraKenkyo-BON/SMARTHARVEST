<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "smartharvest";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$alerts_sql = "SELECT * FROM alerts WHERE solved = FALSE ORDER BY datetime DESC";
$result = $conn->query($alerts_sql);

$alerts = array();
while ($row = $result->fetch_assoc()) {
    $alerts[] = $row;
}

$conn->close();

echo json_encode(array("alerts" => $alerts));
?>
