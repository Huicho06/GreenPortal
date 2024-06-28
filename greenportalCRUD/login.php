<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header('Content-Type: application/json');

// Detalles de conexión proporcionados por 000webhost
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $password = isset($_POST['password']) ? $_POST['password'] : '';

    if (empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Email y contraseña son requeridos']);
        exit();
    }

    $stmt = $conn->prepare("SELECT * FROM usuario WHERE email = ?");
    if (!$stmt) {
        echo json_encode(["success" => false, "message" => "Error en la preparación de la consulta: " . $conn->error]);
        exit();
    }

    $stmt->bind_param("s", $email);
    if (!$stmt->execute()) {
        echo json_encode(["success" => false, "message" => "Error en la ejecución de la consulta: " . $stmt->error]);
        exit();
    }
    
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if (password_verify($password, $row['password'])) {
            // Establecer una cookie con el tipo de usuario
            setcookie("user_type", $row['tipo'], time() + (86400 * 30), "/"); // 86400 = 1 día
            echo json_encode(['success' => true, 'usuario' => $row]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Contraseña inválida']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Usuario no encontrado']);
    }

    $stmt->close();
} else {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
}

$conn->close();
?>
