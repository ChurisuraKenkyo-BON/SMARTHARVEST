<?php
header('Content-Type: application/json');
$targetDir = "C:/xampp/htdocs/SmartHarvest/AZOLLA_PHOTOS/";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $filename = isset($_GET['id']) ? basename($_GET['id']) : null;

    if (!$filename) {
        http_response_code(400);
        echo json_encode(['error' => 'No filename provided']);
        exit;
    }

    $targetFile = $targetDir . $filename;
    if (preg_match('/\.\.(\/|\\\\)/', $filename)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid filename']);
        exit;
    }

    if (file_exists($targetFile)) {
        if (unlink($targetFile)) {
            echo json_encode(['success' => true]);
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'Delete failed: Server error']);
        }
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'File not found']);
    }
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
$allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
$fileExtension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));

if(!in_array($fileExtension, $allowedExtensions)) {
    http_response_code(403);
    echo json_encode(['error' => 'Invalid file type']);
    exit;
}
?>