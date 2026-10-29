CREATE DATABASE IF NOT EXISTS norte_leads
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE norte_leads;

CREATE TABLE municipios (
    id_municipio TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    departamento VARCHAR(60) NOT NULL DEFAULT 'Valle del Cauca',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_municipio_nombre UNIQUE (nombre, departamento)
) ENGINE=InnoDB;

CREATE TABLE planes_servicio (
    id_plan TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    precio_mensual DECIMAL(10,2) UNSIGNED NOT NULL,
    conversaciones_incluidas SMALLINT UNSIGNED NOT NULL,
    citas_objetivo SMALLINT UNSIGNED NOT NULL,
    incluye_llamadas BOOLEAN NOT NULL DEFAULT FALSE,
    descripcion VARCHAR(255) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_plan_nombre UNIQUE (nombre),
    CONSTRAINT chk_plan_precio CHECK (precio_mensual > 0),
    CONSTRAINT chk_plan_conversaciones CHECK (conversaciones_incluidas > 0)
) ENGINE=InnoDB;

CREATE TABLE agentes (
    id_agente SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    documento VARCHAR(20) NOT NULL,
    clave_hash VARCHAR(255) NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(120) NOT NULL,
    rol ENUM('ADMINISTRADOR','COORDINADOR','AGENTE') NOT NULL DEFAULT 'AGENTE',
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_ingreso DATE NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_agente_documento UNIQUE (documento),
    CONSTRAINT uq_agente_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE negocios (
    id_negocio INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_municipio TINYINT UNSIGNED NOT NULL,
    nombre_comercial VARCHAR(120) NOT NULL,
    nit VARCHAR(20) NOT NULL,
    sector VARCHAR(80) NOT NULL,
    persona_contacto VARCHAR(120) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(120) NOT NULL,
    direccion VARCHAR(180) NULL,
    estado ENUM('PROSPECTO','ACTIVO','PAUSADO','RETIRADO') NOT NULL DEFAULT 'PROSPECTO',
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_negocio_nit UNIQUE (nit),
    CONSTRAINT uq_negocio_email UNIQUE (email),
    CONSTRAINT fk_negocio_municipio FOREIGN KEY (id_municipio)
        REFERENCES municipios (id_municipio)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE suscripciones (
    id_suscripcion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_negocio INT UNSIGNED NOT NULL,
    id_plan TINYINT UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    estado ENUM('ACTIVA','PAUSADA','CANCELADA','VENCIDA') NOT NULL DEFAULT 'ACTIVA',
    precio_pactado DECIMAL(10,2) UNSIGNED NOT NULL,
    canal_principal ENUM('WHATSAPP','INSTAGRAM','TELEFONO','MIXTO') NOT NULL DEFAULT 'WHATSAPP',
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_suscripcion_periodo UNIQUE (id_negocio, fecha_inicio),
    CONSTRAINT chk_suscripcion_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT chk_suscripcion_precio CHECK (precio_pactado > 0),
    CONSTRAINT fk_suscripcion_negocio FOREIGN KEY (id_negocio)
        REFERENCES negocios (id_negocio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_suscripcion_plan FOREIGN KEY (id_plan)
        REFERENCES planes_servicio (id_plan)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE prospectos (
    id_prospecto BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_negocio INT UNSIGNED NOT NULL,
    id_agente SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email_cifrado VARBINARY(256) NULL,
    email_iv BINARY(16) NULL,
    fuente ENUM('WHATSAPP','FACEBOOK','INSTAGRAM','REFERIDO','WEB','OTRO') NOT NULL,
    estado ENUM('NUEVO','CONTACTADO','CALIFICADO','CITA','GANADO','PERDIDO') NOT NULL DEFAULT 'NUEVO',
    valor_estimado DECIMAL(12,2) UNSIGNED NOT NULL DEFAULT 0,
    consentimiento_datos BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_gestion DATETIME NULL,
    actualizado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_prospecto_telefono_negocio UNIQUE (id_negocio, telefono),
    CONSTRAINT chk_prospecto_valor CHECK (valor_estimado >= 0),
    CONSTRAINT fk_prospecto_negocio FOREIGN KEY (id_negocio)
        REFERENCES negocios (id_negocio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prospecto_agente FOREIGN KEY (id_agente)
        REFERENCES agentes (id_agente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_prospecto_estado (estado),
    INDEX idx_prospecto_fecha (fecha_registro)
) ENGINE=InnoDB;

CREATE TABLE seguimientos (
    id_seguimiento BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_prospecto BIGINT UNSIGNED NOT NULL,
    id_agente SMALLINT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    canal ENUM('WHATSAPP','LLAMADA','EMAIL','INSTAGRAM','PRESENCIAL') NOT NULL,
    tipo ENUM('ENTRANTE','SALIENTE') NOT NULL,
    resumen VARCHAR(500) NOT NULL,
    resultado ENUM('SIN_RESPUESTA','INTERESADO','NO_INTERESADO','CITA_AGENDADA','VENTA','PENDIENTE') NOT NULL,
    proxima_accion DATETIME NULL,
    duracion_minutos SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_seguimiento_prospecto FOREIGN KEY (id_prospecto)
        REFERENCES prospectos (id_prospecto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_seguimiento_agente FOREIGN KEY (id_agente)
        REFERENCES agentes (id_agente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_seguimiento_fecha (fecha_hora),
    INDEX idx_seguimiento_resultado (resultado)
) ENGINE=InnoDB;

CREATE TABLE citas (
    id_cita BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_prospecto BIGINT UNSIGNED NOT NULL,
    id_agente SMALLINT UNSIGNED NOT NULL,
    fecha_hora DATETIME NOT NULL,
    modalidad ENUM('PRESENCIAL','VIDEOLLAMADA','TELEFONICA') NOT NULL,
    estado ENUM('PROGRAMADA','CONFIRMADA','ATENDIDA','CANCELADA','NO_ASISTIO') NOT NULL DEFAULT 'PROGRAMADA',
    observaciones VARCHAR(300) NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cita_prospecto FOREIGN KEY (id_prospecto)
        REFERENCES prospectos (id_prospecto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cita_agente FOREIGN KEY (id_agente)
        REFERENCES agentes (id_agente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_cita_fecha_estado (fecha_hora, estado)
) ENGINE=InnoDB;

CREATE TABLE pagos (
    id_pago BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_suscripcion INT UNSIGNED NOT NULL,
    fecha_pago DATE NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    valor DECIMAL(10,2) UNSIGNED NOT NULL,
    medio ENUM('TRANSFERENCIA','EFECTIVO','PSE','TARJETA') NOT NULL,
    referencia VARCHAR(50) NOT NULL,
    estado ENUM('PENDIENTE','APROBADO','RECHAZADO','REEMBOLSADO') NOT NULL DEFAULT 'PENDIENTE',
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_pago_referencia UNIQUE (referencia),
    CONSTRAINT chk_pago_periodo CHECK (periodo_fin >= periodo_inicio),
    CONSTRAINT chk_pago_valor CHECK (valor > 0),
    CONSTRAINT fk_pago_suscripcion FOREIGN KEY (id_suscripcion)
        REFERENCES suscripciones (id_suscripcion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_pago_fecha_estado (fecha_pago, estado)
) ENGINE=InnoDB;

CREATE TABLE auditoria_prospectos (
    id_auditoria BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_prospecto BIGINT UNSIGNED NOT NULL,
    estado_anterior VARCHAR(20) NOT NULL,
    estado_nuevo VARCHAR(20) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(128) NOT NULL,
    usuario_conexion VARCHAR(128) NOT NULL,
    CONSTRAINT fk_auditoria_prospecto FOREIGN KEY (id_prospecto)
        REFERENCES prospectos (id_prospecto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_auditoria_fecha (fecha_cambio)
) ENGINE=InnoDB;
