USE norte_leads;

-- Datos ficticios creados solo para fines academicos.

INSERT INTO municipios (id_municipio, nombre, departamento) VALUES
(1, 'Cartago', 'Valle del Cauca'),
(2, 'Roldanillo', 'Valle del Cauca'),
(3, 'La Union', 'Valle del Cauca'),
(4, 'Zarzal', 'Valle del Cauca'),
(5, 'La Victoria', 'Valle del Cauca'),
(6, 'Obando', 'Valle del Cauca'),
(7, 'Toro', 'Valle del Cauca'),
(8, 'Ansermanuevo', 'Valle del Cauca'),
(9, 'Alcala', 'Valle del Cauca'),
(10, 'Ulloa', 'Valle del Cauca');

INSERT INTO planes_servicio (
    id_plan, nombre, precio_mensual, conversaciones_incluidas,
    citas_objetivo, incluye_llamadas, descripcion
) VALUES
(1, 'Validacion', 350000, 120, 4, FALSE, 'Prueba de demanda por treinta dias'),
(2, 'Emprende', 650000, 250, 8, FALSE, 'Respuesta y seguimiento basico por WhatsApp'),
(3, 'Base', 750000, 350, 10, FALSE, 'Calificacion de prospectos y agenda'),
(4, 'Crecimiento', 950000, 500, 14, TRUE, 'Seguimiento multicanal con llamadas'),
(5, 'Agenda', 900000, 450, 18, TRUE, 'Orientado a negocios que venden por cita'),
(6, 'Recuperacion', 700000, 300, 8, TRUE, 'Reactivacion de prospectos sin cierre'),
(7, 'Comercio', 850000, 600, 10, FALSE, 'Atencion de catalogo y pedidos comerciales'),
(8, 'Servicios', 1050000, 550, 16, TRUE, 'Calificacion para servicios profesionales'),
(9, 'Omnicanal', 1300000, 900, 22, TRUE, 'WhatsApp, Instagram, email y llamadas'),
(10, 'Premium', 1500000, 1200, 30, TRUE, 'Operacion dedicada y reporte semanal');

INSERT INTO agentes (
    id_agente, nombre, documento, telefono, email, rol, estado, fecha_ingreso
) VALUES
(1, 'Laura Giraldo', '1001001001', '3102000001', 'laura@norteleads.local', 'ADMINISTRADOR', 'ACTIVO', '2026-01-10'),
(2, 'Mateo Salazar', '1001001002', '3102000002', 'mateo@norteleads.local', 'COORDINADOR', 'ACTIVO', '2026-02-03'),
(3, 'Valentina Rios', '1001001003', '3102000003', 'valentina@norteleads.local', 'AGENTE', 'ACTIVO', '2026-03-01'),
(4, 'Santiago Mora', '1001001004', '3102000004', 'santiago@norteleads.local', 'AGENTE', 'ACTIVO', '2026-03-15'),
(5, 'Daniela Velez', '1001001005', '3102000005', 'daniela@norteleads.local', 'AGENTE', 'ACTIVO', '2026-04-02'),
(6, 'Juan David Ocampo', '1001001006', '3102000006', 'juan@norteleads.local', 'AGENTE', 'ACTIVO', '2026-04-20'),
(7, 'Mariana Quintero', '1001001007', '3102000007', 'mariana@norteleads.local', 'AGENTE', 'ACTIVO', '2026-05-06'),
(8, 'Nicolas Arango', '1001001008', '3102000008', 'nicolas@norteleads.local', 'AGENTE', 'ACTIVO', '2026-05-18'),
(9, 'Sara Castaño', '1001001009', '3102000009', 'sara@norteleads.local', 'AGENTE', 'ACTIVO', '2026-06-04'),
(10, 'Andres Patiño', '1001001010', '3102000010', 'andres@norteleads.local', 'AGENTE', 'ACTIVO', '2026-06-22');

INSERT INTO negocios (
    id_negocio, id_municipio, nombre_comercial, nit, sector,
    persona_contacto, telefono, email, direccion, estado
) VALUES
(1, 1, 'OdontoCentro Cartago', '901900001-1', 'Salud oral', 'Carolina Mesa', '3203000001', 'contacto@odontocentro.demo', 'Carrera 4 # 12-30', 'ACTIVO'),
(2, 1, 'Inmobiliaria La Ermita', '901900002-2', 'Inmobiliario', 'Felipe Torres', '3203000002', 'ventas@laermita.demo', 'Calle 14 # 6-18', 'ACTIVO'),
(3, 2, 'Academia Horizonte', '901900003-3', 'Educacion', 'Paula Cifuentes', '3203000003', 'info@horizonte.demo', 'Calle 8 # 5-40', 'ACTIVO'),
(4, 3, 'Muebles del Valle', '901900004-4', 'Comercio', 'Ricardo Leon', '3203000004', 'pedidos@mueblesvalle.demo', 'Carrera 9 # 10-15', 'ACTIVO'),
(5, 4, 'Centro Fitness Zarzal', '901900005-5', 'Actividad fisica', 'Natalia Ruiz', '3203000005', 'hola@fitnesszarzal.demo', 'Calle 11 # 7-22', 'ACTIVO'),
(6, 5, 'Agroinsumos La Victoria', '901900006-6', 'Agrocomercio', 'Jorge Marin', '3203000006', 'ventas@agrolavictoria.demo', 'Carrera 6 # 9-44', 'ACTIVO'),
(7, 6, 'Taller Motor Norte', '901900007-7', 'Automotriz', 'Camilo Garcia', '3203000007', 'servicio@motornorte.demo', 'Via principal local 12', 'ACTIVO'),
(8, 7, 'Clinica Veterinaria Toro', '901900008-8', 'Veterinario', 'Luisa Restrepo', '3203000008', 'citas@vetoro.demo', 'Calle 5 # 4-17', 'ACTIVO'),
(9, 8, 'Hotel Mirador Norte', '901900009-9', 'Alojamiento', 'Oscar Mejia', '3203000009', 'reservas@miradornorte.demo', 'Carrera 3 # 6-28', 'ACTIVO'),
(10, 9, 'Estetica Natural Alcala', '901900010-0', 'Belleza', 'Monica Franco', '3203000010', 'agenda@naturalalcala.demo', 'Calle 4 # 8-11', 'ACTIVO');

INSERT INTO suscripciones (
    id_suscripcion, id_negocio, id_plan, fecha_inicio, fecha_fin,
    estado, precio_pactado, canal_principal
) VALUES
(1, 1, 5, '2026-09-01', NULL, 'ACTIVA', 900000, 'WHATSAPP'),
(2, 2, 4, '2026-09-01', NULL, 'ACTIVA', 950000, 'MIXTO'),
(3, 3, 3, '2026-09-01', NULL, 'ACTIVA', 750000, 'WHATSAPP'),
(4, 4, 7, '2026-09-01', NULL, 'ACTIVA', 850000, 'INSTAGRAM'),
(5, 5, 5, '2026-09-01', NULL, 'ACTIVA', 900000, 'WHATSAPP'),
(6, 6, 7, '2026-09-01', NULL, 'ACTIVA', 850000, 'TELEFONO'),
(7, 7, 8, '2026-09-01', NULL, 'ACTIVA', 1050000, 'MIXTO'),
(8, 8, 5, '2026-09-01', NULL, 'ACTIVA', 900000, 'WHATSAPP'),
(9, 9, 9, '2026-09-01', NULL, 'ACTIVA', 1300000, 'MIXTO'),
(10, 10, 5, '2026-09-01', NULL, 'ACTIVA', 900000, 'INSTAGRAM');

INSERT INTO prospectos (
    id_prospecto, id_negocio, id_agente, nombre, telefono, email,
    fuente, estado, valor_estimado, consentimiento_datos,
    fecha_registro, fecha_ultima_gestion
) VALUES
(1, 1, 3, 'Ana Beltran', '3101000001', 'ana.beltran@example.test', 'WHATSAPP', 'NUEVO', 180000, TRUE, '2026-09-02 08:10:00', '2026-09-02 08:20:00'),
(2, 1, 3, 'Luis Cardona', '3101000002', 'luis.cardona@example.test', 'INSTAGRAM', 'NUEVO', 240000, TRUE, '2026-09-03 09:15:00', '2026-09-03 09:40:00'),
(3, 2, 4, 'Camila Arias', '3101000003', 'camila.arias@example.test', 'FACEBOOK', 'NUEVO', 280000000, TRUE, '2026-09-03 11:05:00', '2026-09-03 11:30:00'),
(4, 2, 4, 'Julian Perez', '3101000004', 'julian.perez@example.test', 'REFERIDO', 'NUEVO', 190000000, TRUE, '2026-09-04 14:20:00', '2026-09-04 15:00:00'),
(5, 3, 5, 'Sofia Herrera', '3101000005', 'sofia.herrera@example.test', 'WEB', 'NUEVO', 1200000, TRUE, '2026-09-05 10:00:00', '2026-09-05 10:45:00'),
(6, 3, 5, 'Samuel Diaz', '3101000006', 'samuel.diaz@example.test', 'WHATSAPP', 'NUEVO', 900000, TRUE, '2026-09-05 16:10:00', '2026-09-05 16:30:00'),
(7, 4, 6, 'Maria Jose Lopez', '3101000007', 'maria.lopez@example.test', 'INSTAGRAM', 'NUEVO', 3200000, TRUE, '2026-09-06 09:30:00', '2026-09-06 10:00:00'),
(8, 4, 6, 'Carlos Muñoz', '3101000008', 'carlos.munoz@example.test', 'WHATSAPP', 'NUEVO', 4600000, TRUE, '2026-09-06 13:15:00', '2026-09-06 13:40:00'),
(9, 5, 7, 'Isabella Gomez', '3101000009', 'isabella.gomez@example.test', 'FACEBOOK', 'NUEVO', 110000, TRUE, '2026-09-07 08:50:00', '2026-09-07 09:20:00'),
(10, 5, 7, 'Sebastian Cano', '3101000010', 'sebastian.cano@example.test', 'REFERIDO', 'NUEVO', 150000, TRUE, '2026-09-07 17:05:00', '2026-09-07 17:30:00'),
(11, 6, 8, 'Valeria Ortiz', '3101000011', 'valeria.ortiz@example.test', 'WHATSAPP', 'NUEVO', 980000, TRUE, '2026-09-08 07:40:00', NULL),
(12, 6, 8, 'Miguel Angel Rojas', '3101000012', 'miguel.rojas@example.test', 'OTRO', 'NUEVO', 750000, TRUE, '2026-09-08 12:25:00', NULL),
(13, 7, 9, 'Mariana Jaramillo', '3101000013', 'mariana.j@example.test', 'WEB', 'NUEVO', 620000, TRUE, '2026-09-09 08:15:00', NULL),
(14, 7, 9, 'Tomas Escobar', '3101000014', 'tomas.escobar@example.test', 'WHATSAPP', 'NUEVO', 450000, TRUE, '2026-09-09 15:45:00', NULL),
(15, 8, 10, 'Gabriela Sanchez', '3101000015', 'gabriela.s@example.test', 'INSTAGRAM', 'NUEVO', 170000, TRUE, '2026-09-10 09:10:00', NULL),
(16, 8, 10, 'Emiliano Castro', '3101000016', 'emiliano.c@example.test', 'REFERIDO', 'NUEVO', 230000, TRUE, '2026-09-10 16:35:00', NULL),
(17, 9, 3, 'Renata Valencia', '3101000017', 'renata.v@example.test', 'WEB', 'NUEVO', 780000, TRUE, '2026-09-11 10:20:00', NULL),
(18, 9, 3, 'Martin Osorio', '3101000018', 'martin.o@example.test', 'WHATSAPP', 'NUEVO', 560000, TRUE, '2026-09-11 18:05:00', NULL),
(19, 10, 4, 'Luciana Gallego', '3101000019', 'luciana.g@example.test', 'INSTAGRAM', 'NUEVO', 290000, TRUE, '2026-09-12 09:55:00', NULL),
(20, 10, 4, 'Agustin Vargas', '3101000020', 'agustin.v@example.test', 'FACEBOOK', 'NUEVO', 340000, TRUE, '2026-09-12 14:45:00', NULL);

INSERT INTO seguimientos (
    id_seguimiento, id_prospecto, id_agente, fecha_hora, canal, tipo,
    resumen, resultado, proxima_accion, duracion_minutos
) VALUES
(1, 1, 3, '2026-09-02 08:20:00', 'WHATSAPP', 'ENTRANTE', 'Consulta por valoracion inicial', 'INTERESADO', '2026-09-03 08:00:00', 6),
(2, 2, 3, '2026-09-03 09:40:00', 'INSTAGRAM', 'ENTRANTE', 'Pregunta por blanqueamiento', 'PENDIENTE', '2026-09-04 10:00:00', 5),
(3, 3, 4, '2026-09-03 11:30:00', 'LLAMADA', 'SALIENTE', 'Busca vivienda de tres habitaciones', 'CITA_AGENDADA', '2026-09-05 11:00:00', 9),
(4, 4, 4, '2026-09-04 15:00:00', 'WHATSAPP', 'SALIENTE', 'Solicita opciones de financiacion', 'VENTA', NULL, 12),
(5, 5, 5, '2026-09-05 10:45:00', 'EMAIL', 'ENTRANTE', 'Interesada en curso de ingles', 'NO_INTERESADO', NULL, 4),
(6, 6, 5, '2026-09-05 16:30:00', 'WHATSAPP', 'SALIENTE', 'Pidio temario y horarios', 'INTERESADO', '2026-09-08 16:00:00', 7),
(7, 7, 6, '2026-09-06 10:00:00', 'INSTAGRAM', 'ENTRANTE', 'Cotizacion de juego de sala', 'INTERESADO', '2026-09-07 09:00:00', 8),
(8, 8, 6, '2026-09-06 13:40:00', 'WHATSAPP', 'SALIENTE', 'Agenda visita a sala de ventas', 'CITA_AGENDADA', '2026-09-08 10:00:00', 10),
(9, 9, 7, '2026-09-07 09:20:00', 'LLAMADA', 'SALIENTE', 'Solicita plan trimestral', 'VENTA', NULL, 11),
(10, 10, 7, '2026-09-07 17:30:00', 'WHATSAPP', 'SALIENTE', 'No desea continuar por ahora', 'NO_INTERESADO', NULL, 3),
(11, 11, 8, '2026-09-08 08:15:00', 'WHATSAPP', 'ENTRANTE', 'Consulta disponibilidad de fertilizante', 'PENDIENTE', '2026-09-09 08:00:00', 4),
(12, 12, 8, '2026-09-08 13:10:00', 'LLAMADA', 'SALIENTE', 'Sin respuesta en primer intento', 'SIN_RESPUESTA', '2026-09-10 13:00:00', 2),
(13, 13, 9, '2026-09-09 09:00:00', 'WHATSAPP', 'ENTRANTE', 'Pregunta por mantenimiento preventivo', 'INTERESADO', '2026-09-10 09:00:00', 6),
(14, 14, 9, '2026-09-09 16:20:00', 'LLAMADA', 'SALIENTE', 'Cotizacion enviada', 'PENDIENTE', '2026-09-11 16:00:00', 5),
(15, 15, 10, '2026-09-10 09:45:00', 'INSTAGRAM', 'ENTRANTE', 'Consulta vacunacion de mascota', 'INTERESADO', '2026-09-10 12:00:00', 5),
(16, 16, 10, '2026-09-10 17:05:00', 'WHATSAPP', 'SALIENTE', 'Agenda control veterinario', 'CITA_AGENDADA', '2026-09-12 09:00:00', 7),
(17, 17, 3, '2026-09-11 11:00:00', 'EMAIL', 'ENTRANTE', 'Solicita tarifa corporativa', 'INTERESADO', '2026-09-12 11:00:00', 8),
(18, 18, 3, '2026-09-11 18:30:00', 'WHATSAPP', 'SALIENTE', 'Sin respuesta', 'SIN_RESPUESTA', '2026-09-13 10:00:00', 2),
(19, 19, 4, '2026-09-12 10:30:00', 'INSTAGRAM', 'ENTRANTE', 'Solicita disponibilidad para facial', 'INTERESADO', '2026-09-13 09:00:00', 6),
(20, 20, 4, '2026-09-12 15:20:00', 'WHATSAPP', 'SALIENTE', 'Pidio catalogo de servicios', 'PENDIENTE', '2026-09-14 15:00:00', 5);

INSERT INTO citas (
    id_cita, id_prospecto, id_agente, fecha_hora, modalidad, estado, observaciones
) VALUES
(1, 1, 3, '2026-09-15 09:00:00', 'PRESENCIAL', 'CONFIRMADA', 'Valoracion odontologica'),
(2, 3, 4, '2026-09-15 11:00:00', 'PRESENCIAL', 'ATENDIDA', 'Visita a inmueble centro'),
(3, 4, 4, '2026-09-16 15:00:00', 'VIDEOLLAMADA', 'ATENDIDA', 'Revision documental'),
(4, 6, 5, '2026-09-17 16:00:00', 'VIDEOLLAMADA', 'PROGRAMADA', 'Clase diagnostica'),
(5, 7, 6, '2026-09-18 10:00:00', 'PRESENCIAL', 'CONFIRMADA', 'Visita a sala de exhibicion'),
(6, 8, 6, '2026-09-18 14:00:00', 'PRESENCIAL', 'PROGRAMADA', 'Medicion de espacio'),
(7, 9, 7, '2026-09-19 08:00:00', 'PRESENCIAL', 'ATENDIDA', 'Inscripcion y evaluacion'),
(8, 13, 9, '2026-09-19 13:00:00', 'PRESENCIAL', 'CONFIRMADA', 'Diagnostico del vehiculo'),
(9, 16, 10, '2026-09-20 09:00:00', 'PRESENCIAL', 'PROGRAMADA', 'Control veterinario'),
(10, 19, 4, '2026-09-20 15:00:00', 'PRESENCIAL', 'CANCELADA', 'Cliente solicito reprogramar');

INSERT INTO pagos (
    id_pago, id_suscripcion, fecha_pago, periodo_inicio, periodo_fin,
    valor, medio, referencia, estado
) VALUES
(1, 1, '2026-09-01', '2026-09-01', '2026-09-30', 900000, 'TRANSFERENCIA', 'NL-202609-001', 'APROBADO'),
(2, 2, '2026-09-01', '2026-09-01', '2026-09-30', 950000, 'PSE', 'NL-202609-002', 'APROBADO'),
(3, 3, '2026-09-02', '2026-09-01', '2026-09-30', 750000, 'TRANSFERENCIA', 'NL-202609-003', 'APROBADO'),
(4, 4, '2026-09-02', '2026-09-01', '2026-09-30', 850000, 'EFECTIVO', 'NL-202609-004', 'APROBADO'),
(5, 5, '2026-09-03', '2026-09-01', '2026-09-30', 900000, 'PSE', 'NL-202609-005', 'APROBADO'),
(6, 6, '2026-09-03', '2026-09-01', '2026-09-30', 850000, 'TRANSFERENCIA', 'NL-202609-006', 'APROBADO'),
(7, 7, '2026-09-04', '2026-09-01', '2026-09-30', 1050000, 'TARJETA', 'NL-202609-007', 'APROBADO'),
(8, 8, '2026-09-04', '2026-09-01', '2026-09-30', 900000, 'TRANSFERENCIA', 'NL-202609-008', 'APROBADO'),
(9, 9, '2026-09-05', '2026-09-01', '2026-09-30', 1300000, 'PSE', 'NL-202609-009', 'PENDIENTE'),
(10, 10, '2026-09-05', '2026-09-01', '2026-09-30', 900000, 'EFECTIVO', 'NL-202609-010', 'APROBADO');

-- Diez actualizaciones generan diez filas reales en la tabla de auditoria.
UPDATE prospectos SET estado = 'CONTACTADO' WHERE id_prospecto = 1;
UPDATE prospectos SET estado = 'CALIFICADO' WHERE id_prospecto = 2;
UPDATE prospectos SET estado = 'CITA' WHERE id_prospecto = 3;
UPDATE prospectos SET estado = 'GANADO' WHERE id_prospecto = 4;
UPDATE prospectos SET estado = 'PERDIDO' WHERE id_prospecto = 5;
UPDATE prospectos SET estado = 'CONTACTADO' WHERE id_prospecto = 6;
UPDATE prospectos SET estado = 'CALIFICADO' WHERE id_prospecto = 7;
UPDATE prospectos SET estado = 'CITA' WHERE id_prospecto = 8;
UPDATE prospectos SET estado = 'GANADO' WHERE id_prospecto = 9;
UPDATE prospectos SET estado = 'PERDIDO' WHERE id_prospecto = 10;

