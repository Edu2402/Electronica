<?php
function registrarActividad($conexion, $descripcion) {
    $sql = "INSERT INTO actividad (usuario, rol, descripcion)
            VALUES (?, ?, ?)";

    $stmt = $conexion->prepare($sql);
    $stmt->bind_param(
        "sss",
        $_SESSION['nombre'],
        $_SESSION['rol'],
        $descripcion
    );
    $stmt->execute();
}
