<?php
header('Content-Type: application/json');
$conn = new mysqli("localhost", "root", "", "smartharvest");

if ($conn->connect_error) {
    die(json_encode(['error' => 'Database connection failed']));
}
$predictionQuery = "SELECT prediction FROM harvest_predictions ORDER BY timestamp DESC LIMIT 1";
$predictionResult = $conn->query($predictionQuery);
$prediction = $predictionResult->fetch_assoc()['prediction'];
$alertQuery = "SELECT COUNT(*) as unresolved FROM alerts WHERE solved = 0";
$alertResult = $conn->query($alertQuery);
$unresolvedAlerts = $alertResult->fetch_assoc()['unresolved'];
$isHarvestable = ($prediction == 1 && $unresolvedAlerts == 0);
echo json_encode(['isHarvestable' => $isHarvestable]);
$conn->close();
?>