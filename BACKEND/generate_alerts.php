<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "smartharvest";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$sensor_data_sql = "SELECT * FROM sensordata ORDER BY DATADATE DESC LIMIT 1";
$sensor_result = $conn->query($sensor_data_sql);
$sensor_data = $sensor_result->fetch_assoc();

if (!$sensor_data) {
    echo "No sensor data found.";
    exit;
} else {
    echo "Fetched sensor data: ";
    print_r($sensor_data);
}

$thresholds_sql = "SELECT * FROM settings";
$thresholds_result = $conn->query($thresholds_sql);
$thresholds = array();
while ($row = $thresholds_result->fetch_assoc()) {
    $thresholds[$row['parameter']] = $row;
}
echo "Fetched thresholds: ";
print_r($thresholds);
foreach ($thresholds as $parameter => $threshold) {
    $parameter_data = strtoupper($parameter) . "DATA";
    if ($sensor_data[$parameter_data] < $threshold["min_value"] || $sensor_data[$parameter_data] > $threshold["max_value"]) {
        $breached_threshold = ($sensor_data[$parameter_data] < $threshold["min_value"]) ? "min" : "max";
        $alert_sql = "INSERT INTO alerts (sensor_name, sensor_value, threshold_min, threshold_max, breached_threshold) VALUES 
        ('$parameter', {$sensor_data[$parameter_data]}, {$threshold['min_value']}, {$threshold['max_value']}, '$breached_threshold')";
        if ($conn->query($alert_sql) === TRUE) {
            echo "New alert inserted for $parameter.";
        } else {
            echo "Error: " . $alert_sql . "<br>" . $conn->error;
        }
    } else {
        echo "$parameter is within the threshold range.";
    }
}
$conn->close();
?>
