<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    // Just send the headers for preflight
    exit(0);
}

include 'db.php';

$sql = "SELECT id, nombre, descripcion, precio, stock, image FROM producto";
$result = $conn->query($sql);

$products = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $row['image'] = base64_encode($row['image']);  // Convert the image to base64
        $products[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($products);

$conn->close();
?>
