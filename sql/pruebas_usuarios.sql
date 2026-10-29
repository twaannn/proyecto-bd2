-- Cada grupo se ejecuta en una conexion DIFERENTE de Workbench.
-- Host 127.0.0.1, puerto 3307, esquema norte_leads.
-- No basta SET ROLE en una conexion root: hay que cambiar de usuario.

-- USUARIO admin_nl: AdminNL_2026*Demo
-- Permitido. Captura 15_admin_permitido.png
SELECT USER(), CURRENT_USER(), CURRENT_ROLE();
SELECT id_prospecto, fn_email_prospecto(id_prospecto) AS email FROM norte_leads.prospectos WHERE id_prospecto = 1;
-- Denegado: admin del negocio no es root del servidor. Captura 16_admin_denegado.png
SELECT User, Host FROM mysql.user;

-- USUARIO agente_nl: AgenteNL_2026*Demo
-- Permitido. Captura 17_agente_permitido.png
SELECT USER(), CURRENT_USER(), CURRENT_ROLE();
CALL norte_leads.sp_listar_prospectos_negocio(1);
-- Denegado: no puede acceder a los hashes de agentes. Captura 18_agente_denegado.png
SELECT clave_hash FROM norte_leads.agentes;

-- USUARIO consulta_nl: ConsultaNL_2026*Demo
-- Permitido. Captura 19_consulta_permitido.png
SELECT USER(), CURRENT_USER(), CURRENT_ROLE();
SELECT * FROM norte_leads.vw_prospectos_publico WHERE id_prospecto <= 2;
-- Denegado: no puede leer la tabla original. Captura 20_consulta_denegado.png
SELECT nombre, telefono FROM norte_leads.prospectos;

-- Politica de contrasenas, solo con root; falla sin crear la cuenta. Captura 21_politica.png
CREATE USER 'clave_invalida_nl'@'%' IDENTIFIED BY 'abc';
