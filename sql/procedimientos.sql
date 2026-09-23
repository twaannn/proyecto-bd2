USE norte_leads;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_listar_prospectos_negocio$$
-- Procedimiento 1: recibe un parametro IN y muestra los prospectos del negocio.
CREATE PROCEDURE sp_listar_prospectos_negocio(
    IN p_id_negocio INT UNSIGNED
)
BEGIN
    SELECT
        p.id_prospecto,
        p.nombre AS prospecto,
        p.estado,
        a.nombre AS agente
    FROM prospectos p
    INNER JOIN agentes a
        ON p.id_agente = a.id_agente
    WHERE p.id_negocio = p_id_negocio
    ORDER BY p.nombre;
END$$

DROP PROCEDURE IF EXISTS sp_contar_prospectos$$
-- Procedimiento 2: recibe un IN y devuelve el total mediante un OUT.
CREATE PROCEDURE sp_contar_prospectos(
    IN p_id_negocio INT UNSIGNED,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM prospectos
    WHERE id_negocio = p_id_negocio;
END$$

DROP PROCEDURE IF EXISTS sp_registrar_intento$$
-- Procedimiento 3: incrementa un INOUT y registra un seguimiento sencillo.
CREATE PROCEDURE sp_registrar_intento(
    IN p_id_prospecto BIGINT UNSIGNED,
    IN p_id_agente SMALLINT UNSIGNED,
    IN p_resumen VARCHAR(500),
    INOUT p_numero_intento INT
)
BEGIN
    SET p_numero_intento = p_numero_intento + 1;

    INSERT INTO seguimientos (
        id_prospecto,
        id_agente,
        canal,
        tipo,
        resumen,
        resultado,
        proxima_accion,
        duracion_minutos
    ) VALUES (
        p_id_prospecto,
        p_id_agente,
        'WHATSAPP',
        'SALIENTE',
        CONCAT('Intento ', p_numero_intento, ': ', p_resumen),
        'PENDIENTE',
        NULL,
        0
    );
END$$

DELIMITER ;
