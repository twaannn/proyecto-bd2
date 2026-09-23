USE norte_leads;

DELIMITER $$

-- Trigger basico de auditoria con OLD y NEW.
DROP TRIGGER IF EXISTS trg_prospecto_auditar_estado$$
CREATE TRIGGER trg_prospecto_auditar_estado
AFTER UPDATE ON prospectos
FOR EACH ROW
BEGIN
    IF OLD.estado <> NEW.estado THEN
        INSERT INTO auditoria_prospectos (
            id_prospecto,
            estado_anterior,
            estado_nuevo,
            usuario_bd
        ) VALUES (
            NEW.id_prospecto,
            OLD.estado,
            NEW.estado,
            CURRENT_USER()
        );
    END IF;
END$$

DELIMITER ;
