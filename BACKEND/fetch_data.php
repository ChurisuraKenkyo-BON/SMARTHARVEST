<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "smartharvest";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$sql = "SELECT * FROM sensordata ORDER BY DATADATE DESC LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $data = array(
            "ph" => $row["PHDATA"],
            "humidity" => $row["HUMIDDATA"],
            "temperature" => $row["TEMPDATA"],
            "tds" => $row["TDSDATA"],
            "date" => $row["DATADATE"]
        );
    }
    echo json_encode($data);
} else {
    echo json_encode(array("error" => "No data found"));
}

$conn->close();
?>
