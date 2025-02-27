<?php
$servername = "localhost";
$username = "root";
$password = ""; 
$dbname = "smartharvest";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$data = json_decode(file_get_contents('php://input'), true);

if (is_array($data)) {
    $success = true;
    foreach ($data as $setting) {
        if (isset($setting['parameter']) && isset($setting['min_value']) && isset($setting['max_value'])) {
            $parameter = $setting['parameter'];
            $min_value = intval($setting['min_value']);
            $max_value = intval($setting['max_value']);

            $sql = "UPDATE settings SET min_value = ?, max_value = ? WHERE parameter = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('iis', $min_value, $max_value, $parameter);

            if (!$stmt->execute()) {
                $success = false;
                break;
            }
            $stmt->close();
        } else {
            $success = false;
            break;
        }
    }

    if ($success) {
        echo json_encode(array("success" => "Settings updated successfully"));
    } else {
        echo json_encode(array("error" => "Error updating settings"));
    }
} else {
    echo json_encode(array("error" => "Invalid input"));
}

$conn->close();
?>
