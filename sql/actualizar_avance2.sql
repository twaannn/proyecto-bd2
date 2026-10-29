USE norte_leads;
-- Ejecutar UNA VEZ sobre la base del primer corte, despues del respaldo.
ALTER TABLE agentes ADD COLUMN IF NOT EXISTS clave_hash VARCHAR(255) NULL AFTER documento;
ALTER TABLE prospectos ADD COLUMN IF NOT EXISTS email_cifrado VARBINARY(256) NULL AFTER email;
ALTER TABLE prospectos ADD COLUMN IF NOT EXISTS email_iv BINARY(16) NULL AFTER email_cifrado;
ALTER TABLE auditoria_prospectos
 ADD COLUMN IF NOT EXISTS usuario_conexion VARCHAR(128) NOT NULL
 DEFAULT 'NO_REGISTRADO_AVANCE_1' AFTER usuario_bd;
SET @clave_nl = UNHEX(LEFT(LOAD_FILE('/run/secrets/clave_cifrado'), 64));
DELIMITER $$
BEGIN NOT ATOMIC
 IF @clave_nl IS NULL OR OCTET_LENGTH(@clave_nl) <> 32 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pudo leer la clave local de cifrado';
 END IF;
END$$
DELIMITER ;
UPDATE prospectos SET email_iv = RANDOM_BYTES(16) WHERE email IS NOT NULL;
UPDATE prospectos
 SET email_cifrado = AES_ENCRYPT(email, @clave_nl, email_iv, 'aes-256-cbc')
 WHERE email IS NOT NULL;
-- Se elimina la copia en texto legible del correo.
ALTER TABLE prospectos DROP COLUMN email;
UPDATE agentes SET clave_hash = '$2b$12$d/ciNNhjvggmzmeSwdj6fOSyaYA1IfTYeN9ia/aHD/fRHrydE7seu' WHERE id_agente = 1;
UPDATE agentes SET clave_hash = '$2b$12$Msqa4/PTFfKaRTDbYyvqJesG4QaG4GT7QFS6.mlZZJcKszpywscxu' WHERE id_agente = 2;
UPDATE agentes SET clave_hash = '$2b$12$cek2fxapKbUvd1SbZVZ7Uu1G1HuNzdaih4ITWtIRynAXRdwBrijhC' WHERE id_agente = 3;
UPDATE agentes SET clave_hash = '$2b$12$bnPzdCsp2KlwIhOutqLvxui53nfyRLeGLysiobc5m1QSmjG4kgwYC' WHERE id_agente = 4;
UPDATE agentes SET clave_hash = '$2b$12$NrmpKn9b/P.4R4Lar3pegu.DJixlWFR2epSA4iEvf6VtLoBxEuuRu' WHERE id_agente = 5;
UPDATE agentes SET clave_hash = '$2b$12$f2UfGqnEzHTe99sIhcna2OvoFlE2kypwSoXOBh4Bw9Htn/L0Fy0kS' WHERE id_agente = 6;
UPDATE agentes SET clave_hash = '$2b$12$gIlaey./D8O5HoV6pYV6WerNola3UAPWxLdXstq86aTFCIwT6RMPK' WHERE id_agente = 7;
UPDATE agentes SET clave_hash = '$2b$12$L22utYjS95MD1gEgCSEmXuK9donRgQ0/UAv6iA4CiCoP1UrvLBJ2K' WHERE id_agente = 8;
UPDATE agentes SET clave_hash = '$2b$12$G/GpsZofdYXDB5truiKpeO0m9VZE9DGgGX6SuTdD5CAwnCm4hx.3C' WHERE id_agente = 9;
UPDATE agentes SET clave_hash = '$2b$12$JnF65hZb4gh5YjGS9geWvOSegf/XoDQqJO0UFL1brFByThlTORi8q' WHERE id_agente = 10;
SET @clave_nl = NULL;
