<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header('Content-Type: application/json');

include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $nombre = $_POST['nombre'];
    $descripcion = $_POST['descripcion'];
    $precio = $_POST['precio'];
    $stock = $_POST['stock'];
    $image = isset($_POST['image']) ? base64_decode($_POST['image']) : null;

    if ($image !== null) {
        $stmt = $conn->prepare("UPDATE producto SET nombre = ?, descripcion = ?, precio = ?, stock = ?, image = ? WHERE id = ?");
        $stmt->bind_param("ssdisi", $nombre, $descripcion, $precio, $stock, $image, $id);
    } else {
        $stmt = $conn->prepare("UPDATE producto SET nombre = ?, descripcion = ?, precio = ?, stock = ? WHERE id = ?");
        $stmt->bind_param("ssdii", $nombre, $descripcion, $precio, $stock, $id);
    }

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Producto actualizado exitosamente']);
    } else {
        echo json_encode(['success' => false, 'message' => $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Método de solicitud no válido']);
}

$conn->close();
?>
