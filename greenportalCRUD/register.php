<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header('Content-Type: application/json');
// Detalles de conexión proporcionados por 000webhost

$servername = "localhost:3309";
$username = "root";
$password = "";
$dbname = "greenportal";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Conexión fallida: " . $conn->connect_error]);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nombre = isset($_POST['nombre']) ? $_POST['nombre'] : '';
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $password = isset($_POST['password']) ? password_hash($_POST['password'], PASSWORD_BCRYPT) : '';

    if (empty($nombre) || empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Nombre, email y contraseña son requeridos']);
        exit();
    }

    $stmt = $conn->prepare("INSERT INTO usuario (nombre, email, password) VALUES (?, ?, ?)");
    if (!$stmt) {
        echo json_encode(["success" => false, "message" => "Error en la preparación de la consulta: " . $conn->error]);
        exit();
    }

    $stmt->bind_param("sss", $nombre, $email, $password);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Nuevo registro creado exitosamente']);
    } else {
        echo json_encode(['success' => false, 'message' => $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
}

$conn->close();
?>
