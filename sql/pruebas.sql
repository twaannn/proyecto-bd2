-- Abrir con root o admin_nl. Ejecutar cada bloque por separado.
-- Los errores comentados son pruebas INTENCIONALES: no ejecutar todo el archivo de una vez.
USE norte_leads;

-- P1 EXITO. Captura 01_p1_exito.png
CALL sp_listar_prospectos_negocio(1);
-- P1 ERROR. Captura 02_p1_error.png
CALL sp_listar_prospectos_negocio(999);

-- P2 EXITO. Seleccionar las tres instrucciones juntas. Captura 03_p2_exito.png
SET @total = 0;
CALL sp_contar_prospectos(1, @total);
SELECT @total AS total_prospectos;
-- P2 ERROR. Captura 04_p2_error.png
CALL sp_contar_prospectos(999, @total);

-- P3 EXITO. Captura 05_p3_exito.png (valor 3 y nueva fila).
SET @intento = 2;
CALL sp_registrar_intento(11, 8, 'Seguimiento del segundo corte', @intento);
SELECT @intento AS intento_actual;
SELECT id_seguimiento, id_prospecto, resumen FROM seguimientos
WHERE id_prospecto = 11 ORDER BY id_seguimiento DESC;
-- P3 ERROR: resumen vacio. Captura 06_p3_error.png
SET @intento = 2;
CALL sp_registrar_intento(11, 8, '', @intento);

-- F1: funcion dentro de SELECT. Captura 07_funcion_total.png
SELECT id_prospecto, fn_total_seguimientos(id_prospecto) AS total_seguimientos
FROM prospectos WHERE id_prospecto = 11;
-- F2: dato guardado cifrado y retorno legible para admin. Captura 08_funcion_cifrado.png
SELECT id_prospecto, HEX(email_cifrado) AS email_guardado,
       fn_email_prospecto(id_prospecto) AS email_descifrado
FROM prospectos WHERE id_prospecto = 1;

-- T1: preparar en NUEVO antes de probar. La preparacion tambien puede generar auditoria.
UPDATE prospectos SET estado = 'NUEVO' WHERE id_prospecto = 20;
-- Ejecutar y capturar el cambio siguiente. Captura 09_trigger_auditoria.png
UPDATE prospectos SET estado = 'CONTACTADO' WHERE id_prospecto = 20;
SELECT id_prospecto, estado_anterior, estado_nuevo, usuario_conexion, usuario_bd, fecha_cambio
FROM auditoria_prospectos WHERE id_prospecto = 20 ORDER BY id_auditoria DESC LIMIT 1;

-- T2: los espacios exteriores desaparecen antes de guardar. Captura 10_trigger_resumen.png
INSERT INTO seguimientos (id_prospecto,id_agente,canal,tipo,resumen,resultado)
VALUES (11,8,'WHATSAPP','SALIENTE','   Contacto de prueba   ','PENDIENTE');
SELECT id_seguimiento, CONCAT('[',resumen,']') AS resumen_guardado
FROM seguimientos WHERE id_prospecto = 11 ORDER BY id_seguimiento DESC LIMIT 1;

-- V1: vista con JOIN. Captura 11_vista_join.png
SELECT * FROM vw_prospectos_negocio WHERE id_prospecto <= 2;
-- V2: vista que enmascara nombre y telefono. Captura 12_vista_mascara.png
SELECT * FROM vw_prospectos_publico WHERE id_prospecto <= 2;

-- HASH: como admin. La sal esta incluida en cada cadena bcrypt. Captura 13_hash_bd.png
SELECT id_agente, clave_hash FROM agentes WHERE id_agente IN (1,2);
-- Complementar con la salida PHP: captura 14_hash_php.png
-- En WSL: docker compose exec -T app php /var/www/html/scripts/hash_demo.php
