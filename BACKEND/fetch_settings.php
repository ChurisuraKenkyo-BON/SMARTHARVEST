<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "smartharvest";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$sql = "SELECT * FROM settings";
$result = $conn->query($sql);

$settings = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $settings[] = $row;
    }
    echo json_encode($settings);
} else {
    echo json_encode(array("error" => "No data found"));
}

$conn->close();
?>
