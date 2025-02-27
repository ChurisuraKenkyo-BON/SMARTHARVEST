<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "smartharvest";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $humidity = $_POST["humidity"];
    $temperature = $_POST["temperature"];
    $tds = $_POST["tds"];
    $ph = $_POST["ph"];
    
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $stmt = $conn->prepare("INSERT INTO sensordata (PHDATA, HUMIDDATA, TEMPDATA, TDSDATA) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("dddd", $ph, $humidity, $temperature, $tds);

    if ($stmt->execute()) {
        echo "Data received and stored successfully!";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
    $conn->close();
} else {
    echo "Invalid request method.";
}
?>