USE norte_leads;
DELIMITER $$
DROP FUNCTION IF EXISTS fn_total_seguimientos$$
CREATE DEFINER=`root`@`localhost` FUNCTION fn_total_seguimientos(p_id_prospecto BIGINT UNSIGNED)
RETURNS INT
NOT DETERMINISTIC READS SQL DATA
SQL SECURITY DEFINER
BEGIN
    DECLARE v_total INT;
    SELECT COUNT(*) INTO v_total FROM seguimientos WHERE id_prospecto = p_id_prospecto;
    RETURN v_total;
END$$

-- Solo el rol administrador puede ejecutar esta funcion.
-- La clave se lee del secreto del servidor, nunca se devuelve.
DROP FUNCTION IF EXISTS fn_email_prospecto$$
CREATE DEFINER=`root`@`localhost` FUNCTION fn_email_prospecto(p_id_prospecto BIGINT UNSIGNED)
RETURNS VARCHAR(120) CHARACTER SET utf8mb4
NOT DETERMINISTIC READS SQL DATA
SQL SECURITY DEFINER
BEGIN
    DECLARE v_clave VARBINARY(32);
    DECLARE v_email VARCHAR(120);
    SET v_clave = UNHEX(LEFT(LOAD_FILE('/run/secrets/clave_cifrado'), 64));
    IF v_clave IS NULL OR OCTET_LENGTH(v_clave) <> 32 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Clave local de cifrado no disponible';
    END IF;
    SELECT CONVERT(AES_DECRYPT(email_cifrado, v_clave, email_iv, 'aes-256-cbc') USING utf8mb4)
    INTO v_email FROM prospectos WHERE id_prospecto = p_id_prospecto;
    RETURN v_email;
END$$
DELIMITER ;
