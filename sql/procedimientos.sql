USE norte_leads;
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_listar_prospectos_negocio$$
CREATE DEFINER=`root`@`localhost` PROCEDURE sp_listar_prospectos_negocio(IN p_id_negocio INT UNSIGNED)
SQL SECURITY DEFINER
BEGIN
    DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe FROM negocios WHERE id_negocio = p_id_negocio;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El negocio no existe';
    END IF;
    SELECT p.id_prospecto, p.nombre AS prospecto, p.estado, a.nombre AS agente
    FROM prospectos p
    INNER JOIN agentes a ON p.id_agente = a.id_agente
    WHERE p.id_negocio = p_id_negocio
    ORDER BY p.nombre;
END$$

DROP PROCEDURE IF EXISTS sp_contar_prospectos$$
CREATE DEFINER=`root`@`localhost` PROCEDURE sp_contar_prospectos(IN p_id_negocio INT UNSIGNED, OUT p_total INT)
SQL SECURITY DEFINER
BEGIN
    DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe FROM negocios WHERE id_negocio = p_id_negocio;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El negocio no existe';
    END IF;
    SELECT COUNT(*) INTO p_total FROM prospectos WHERE id_negocio = p_id_negocio;
END$$

DROP PROCEDURE IF EXISTS sp_registrar_intento$$
CREATE DEFINER=`root`@`localhost` PROCEDURE sp_registrar_intento(
    IN p_id_prospecto BIGINT UNSIGNED,
    IN p_id_agente SMALLINT UNSIGNED,
    IN p_resumen VARCHAR(500),
    INOUT p_numero_intento INT
)
SQL SECURITY DEFINER
BEGIN
    DECLARE v_existe INT;
    SELECT COUNT(*) INTO v_existe FROM prospectos WHERE id_prospecto = p_id_prospecto;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El prospecto no existe';
    END IF;
    SELECT COUNT(*) INTO v_existe FROM agentes
    WHERE id_agente = p_id_agente AND estado = 'ACTIVO';
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El agente no existe o esta inactivo';
    END IF;
    IF p_resumen IS NULL OR TRIM(p_resumen) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El resumen es obligatorio';
    END IF;
    IF p_numero_intento IS NULL OR p_numero_intento < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El intento debe ser cero o mayor';
    END IF;
    SET p_numero_intento = p_numero_intento + 1;
    INSERT INTO seguimientos
       (id_prospecto, id_agente, canal, tipo, resumen, resultado, proxima_accion, duracion_minutos)
    VALUES
       (p_id_prospecto, p_id_agente, 'WHATSAPP', 'SALIENTE',
        CONCAT('Intento ', p_numero_intento, ': ', TRIM(p_resumen)), 'PENDIENTE', NULL, 0);
END$$
DELIMITER ;
