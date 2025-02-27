<?php
$dir = 'C:\\xampp\\htdocs\\SmartHarvest\\AZOLLA_PHOTOS\\';
$files = array_diff(scandir($dir), array('..', '.'));
$images = [];

foreach ($files as $file) {
    if (preg_match('/\.(jpg|jpeg)$/i', $file)) {
        $images[] = ['filename' => $file];
    }
}

header('Content-Type: application/json');
echo json_encode($images);
?>
