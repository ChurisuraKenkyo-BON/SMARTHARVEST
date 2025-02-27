<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "smartharvest";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    error_log("Connection failed: " . $conn->connect_error);
    die("Connection failed: " . $conn->connect_error);
}
$prediction = isset($_POST['prediction']) ? intval($_POST['prediction']) : null;
error_log("Received prediction: " . $prediction);

if ($prediction !== null) {
    $stmt = $conn->prepare("INSERT INTO harvest_predictions (prediction, timestamp) VALUES (?, NOW())");
    if ($stmt === false) {
        error_log("Prepare failed: " . $conn->error);
        die("Prepare failed: " . $conn->error);
    }
    $stmt->bind_param("i", $prediction);
    if ($stmt->execute()) {
        echo json_encode(["message" => "Prediction saved successfully!"]);
        error_log("Prediction saved successfully!");
    } else {
        echo json_encode(["message" => "Failed to save prediction.", "error" => $stmt->error]);
        error_log("Failed to save prediction: " . $stmt->error);
    }
    $stmt->close();
} else {
    echo json_encode(["message" => "No prediction data received."]);
    error_log("No prediction data received.");
}
$conn->close();
?>
