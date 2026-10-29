USE norte_leads;
CREATE OR REPLACE DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW vw_prospectos_negocio AS
SELECT p.id_prospecto, n.nombre_comercial AS negocio,
       p.nombre AS prospecto, p.estado, a.nombre AS agente
FROM prospectos p
INNER JOIN negocios n ON p.id_negocio = n.id_negocio
INNER JOIN agentes a ON p.id_agente = a.id_agente;

CREATE OR REPLACE DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW vw_prospectos_publico AS
SELECT id_prospecto,
       CONCAT(LEFT(nombre, 1), '***') AS nombre_visible,
       CONCAT('******', RIGHT(telefono, 4)) AS telefono_visible,
       estado
FROM prospectos;
