USE norte_leads;
DELIMITER $$
DROP TRIGGER IF EXISTS trg_prospecto_auditar_estado$$
CREATE DEFINER=`root`@`localhost` TRIGGER trg_prospecto_auditar_estado
AFTER UPDATE ON prospectos
FOR EACH ROW
BEGIN
    IF OLD.estado <> NEW.estado THEN
        INSERT INTO auditoria_prospectos
            (id_prospecto, estado_anterior, estado_nuevo, usuario_bd, usuario_conexion)
        VALUES
            (NEW.id_prospecto, OLD.estado, NEW.estado, CURRENT_USER(), USER());
    END IF;
END$$

DROP TRIGGER IF EXISTS trg_seguimiento_validar_resumen$$
CREATE DEFINER=`root`@`localhost` TRIGGER trg_seguimiento_validar_resumen
BEFORE INSERT ON seguimientos
FOR EACH ROW
BEGIN
    IF NEW.resumen IS NULL OR TRIM(NEW.resumen) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El seguimiento necesita un resumen';
    END IF;
    SET NEW.resumen = TRIM(NEW.resumen);
END$$
DELIMITER ;
