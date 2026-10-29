USE norte_leads;
-- Los privilegios se asignan a roles, y los roles a las tres cuentas.
CREATE OR REPLACE ROLE rol_admin_nl WITH ADMIN 'root'@'localhost';
CREATE OR REPLACE ROLE rol_agente_nl WITH ADMIN 'root'@'localhost';
CREATE OR REPLACE ROLE rol_consulta_nl WITH ADMIN 'root'@'localhost';

CREATE USER IF NOT EXISTS 'admin_nl'@'%' IDENTIFIED BY 'AdminNL_2026*Demo';
CREATE USER IF NOT EXISTS 'agente_nl'@'%' IDENTIFIED BY 'AgenteNL_2026*Demo';
CREATE USER IF NOT EXISTS 'consulta_nl'@'%' IDENTIFIED BY 'ConsultaNL_2026*Demo';
-- Restablecimiento exclusivo de estas cuentas ficticias del laboratorio.
ALTER USER 'admin_nl'@'%' IDENTIFIED BY 'AdminNL_2026*Demo';
ALTER USER 'agente_nl'@'%' IDENTIFIED BY 'AgenteNL_2026*Demo';
ALTER USER 'consulta_nl'@'%' IDENTIFIED BY 'ConsultaNL_2026*Demo';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_nl'@'%';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'agente_nl'@'%';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'consulta_nl'@'%';

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON norte_leads.* TO rol_admin_nl;
GRANT SELECT ON norte_leads.vw_prospectos_negocio TO rol_agente_nl;
GRANT SELECT ON norte_leads.vw_prospectos_publico TO rol_agente_nl;
GRANT SELECT ON norte_leads.seguimientos TO rol_agente_nl;
GRANT SELECT (id_prospecto, estado), UPDATE (estado) ON norte_leads.prospectos TO rol_agente_nl;
GRANT SELECT ON norte_leads.auditoria_prospectos TO rol_agente_nl;
GRANT EXECUTE ON PROCEDURE norte_leads.sp_listar_prospectos_negocio TO rol_agente_nl;
GRANT EXECUTE ON PROCEDURE norte_leads.sp_contar_prospectos TO rol_agente_nl;
GRANT EXECUTE ON PROCEDURE norte_leads.sp_registrar_intento TO rol_agente_nl;
GRANT EXECUTE ON FUNCTION norte_leads.fn_total_seguimientos TO rol_agente_nl;
GRANT SELECT ON norte_leads.vw_prospectos_publico TO rol_consulta_nl;

GRANT rol_admin_nl TO 'admin_nl'@'%';
GRANT rol_agente_nl TO 'agente_nl'@'%';
GRANT rol_consulta_nl TO 'consulta_nl'@'%';
SET DEFAULT ROLE rol_admin_nl FOR 'admin_nl'@'%';
SET DEFAULT ROLE rol_agente_nl FOR 'agente_nl'@'%';
SET DEFAULT ROLE rol_consulta_nl FOR 'consulta_nl'@'%';
-- Cierra la cuenta amplia del primer corte si existe en el volumen anterior.
ALTER USER IF EXISTS 'norteleads_app'@'%' ACCOUNT LOCK;
