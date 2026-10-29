<?php
try {
    $db = new PDO('mysql:host=' . getenv('DB_HOST') . ';port=3306;dbname=norte_leads;charset=utf8mb4',
        getenv('DB_USER'), getenv('DB_PASSWORD'), [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $filas = $db->query('SELECT * FROM vw_prospectos_publico ORDER BY id_prospecto')->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    http_response_code(503);
    exit('No se pudo conectar a NorteLeads. Revisa el servicio db.');
}
?>
<!doctype html><html lang="es"><meta charset="utf-8"><title>NorteLeads</title>
<style>body{font:16px system-ui;max-width:950px;margin:35px auto;padding:15px;color:#182630}table{border-collapse:collapse;width:100%}th,td{padding:10px;border:1px solid #ddd;text-align:left}th{background:#edf2f4}</style>
<h1>NorteLeads</h1><p>Conexión activa. Datos mostrados mediante la vista enmascarada.</p>
<table><tr><th>ID</th><th>Nombre</th><th>Teléfono</th><th>Estado</th></tr>
<?php foreach ($filas as $f): ?><tr><?php foreach ($f as $v): ?><td><?= htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8') ?></td><?php endforeach; ?></tr><?php endforeach; ?>
</table></html>
