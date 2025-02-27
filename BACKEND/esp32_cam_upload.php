<?php
$targetDir = "C:\\xampp\\htdocs\\SmartHarvest\\AZOLLA_PHOTOS\\";

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['photo'])) {
    $timestamp = time();
    $image = $_FILES['photo'];
    $extension = pathinfo($image['name'], PATHINFO_EXTENSION);
    $targetFile = $targetDir . $timestamp . '.' . $extension;

    if (move_uploaded_file($image['tmp_name'], $targetFile)) {
        echo "The file " . htmlspecialchars(basename($image['name'])) . " has been uploaded as " . $timestamp . '.' . $extension;
    } else {
        echo "Sorry, there was an error uploading your file.";
    }
} else {
    echo "No image file uploaded.";
}
?>
