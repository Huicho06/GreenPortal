<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header('Content-Type: application/json');
// Detalles de conexión proporcionados por 000webhost

include 'db.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombre = $_POST['nombre'];
    $descripcion = $_POST['descripcion'];
    $precio = $_POST['precio'];
    $image = isset($_POST['image']) ? base64_decode($_POST['image']) : null;

    if ($image !== null) {
        $stmt = $conn->prepare("INSERT INTO producto (nombre, descripcion, precio, image) VALUES (?, ?, ?, ?)");
        if ($stmt === false) {
            echo json_encode(['success' => false, 'message' => 'Preparación fallida: ' . $conn->error]);
            exit();
        }
        $stmt->bind_param("ssss", $nombre, $descripcion, $precio, $image);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Producto agregado exitosamente']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Ejecución fallida: ' . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(['success' => false, 'message' => 'Los datos de la imagen faltan o son inválidos']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Método de solicitud no válido']);
}

$conn->close();
?>
