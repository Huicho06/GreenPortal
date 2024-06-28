<?php

$servername = "localhost:3309";
$username = "root";
$password = "";
$dbname = "greenportal";
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
?>
