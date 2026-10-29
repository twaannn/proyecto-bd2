<?php
// Ejecutar por terminal; no publicar esta demostracion por HTTP.
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
$clave = 'AgentesNL_2026*Demo';
$hash1 = password_hash($clave, PASSWORD_BCRYPT, ['cost' => 12]);
$hash2 = password_hash($clave, PASSWORD_BCRYPT, ['cost' => 12]);
echo "Hash 1: $hash1\nHash 2: $hash2\n";
echo 'Distintos por sal aleatoria: ' . ($hash1 !== $hash2 ? 'SI' : 'NO') . "\n";
echo 'Clave correcta: ' . (password_verify($clave, $hash1) ? 'ACEPTADA' : 'RECHAZADA') . "\n";
echo 'Clave incorrecta: ' . (password_verify('NoEsLaClave', $hash1) ? 'ACEPTADA' : 'RECHAZADA') . "\n";
