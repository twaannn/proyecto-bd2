# NorteLeads

## Segundo avance de Bases de Datos II

NorteLeads es una base de datos para organizar la atención comercial de microempresas de Cartago y el norte del Valle del Cauca. El sistema registra negocios, prospectos, agentes, seguimientos, citas, planes de servicio, suscripciones, pagos y cambios de estado.

El proyecto utiliza MariaDB 11.4, PHP 8.3, phpMyAdmin y Docker Compose. Incluye diez tablas relacionadas, tres procedimientos almacenados con parámetros `IN`, `OUT` e `INOUT`, dos funciones, dos triggers, dos vistas y tres roles con diferentes privilegios.

## Componentes del proyecto

| Ruta | Contenido |
| --- | --- |
| `docker-compose.yml` | Configuración de MariaDB, PHP y phpMyAdmin. |
| `Dockerfile` | Construcción del contenedor de la aplicación PHP. |
| `index.php` | Aplicación PHP que consulta la vista enmascarada. |
| `config/mariadb.cnf` | Configuración de MariaDB y política de contraseñas. |
| `sql/esquema.sql` | Creación de las diez tablas y sus restricciones. |
| `sql/datos_prueba.sql` | Registros ficticios utilizados en las pruebas. |
| `sql/procedimientos.sql` | Definición de los tres procedimientos almacenados. |
| `sql/funciones.sql` | Funciones de conteo y recuperación autorizada del correo. |
| `sql/triggers.sql` | Auditoría de estados y validación de resúmenes. |
| `sql/vistas.sql` | Vista operativa con JOIN y vista con datos enmascarados. |
| `sql/seguridad.sql` | Roles, usuarios y privilegios. |
| `sql/actualizar_avance2.sql` | Migración de la base utilizada en el primer avance. |
| `sql/pruebas.sql` | Pruebas de procedimientos, funciones, triggers y vistas. |
| `sql/pruebas_usuarios.sql` | Operaciones permitidas y denegadas para cada usuario. |
| `scripts/hash_demo.php` | Demostración de generación y verificación de hashes bcrypt. |
| `modelado/mer.mwb` | Modelo actualizado para MySQL Workbench. |
| `evidencias/` | Capturas reales de las pruebas realizadas. |
| `docs/Avance2_Roman_Antoine.pdf` | Informe académico del segundo avance. |
| `preparar.sh` | Preparación de la clave local y los recursos requeridos. |
| `actualizar.sh` | Aplicación controlada de la migración del segundo avance. |

## Requisitos

Para ejecutar el proyecto se requiere:

- Docker Engine.
- Docker Compose.
- WSL Ubuntu o una terminal compatible con Bash.
- MySQL Workbench para consultar y visualizar el modelo.

## Instalación sobre una base nueva

Desde WSL, ingresa a la carpeta que contiene `docker-compose.yml` y ejecuta:

```bash
bash preparar.sh
docker compose up -d --build --wait
docker compose ps
```

`preparar.sh` genera una clave aleatoria local para el cifrado de correos y prepara los recursos requeridos por Docker.

La clave se almacena en:

```text
secrets/clave_cifrado.txt
```

La carpeta `secrets/` está excluida de Git y del contexto de construcción de Docker. La clave debe conservarse junto con los respaldos de la base de datos, ya que los correos cifrados no pueden recuperarse sin ella.

Los scripts SQL de inicialización se ejecutan automáticamente cuando MariaDB utiliza un volumen vacío. No se deben ejecutar nuevamente `esquema.sql` ni `datos_prueba.sql` sobre una base que ya contenga los registros.

## Actualización desde el primer avance

Para conservar los datos del primer corte, utiliza:

```bash
bash actualizar.sh
```

El script realiza las siguientes operaciones:

1. Inicia los servicios necesarios.
2. Solicita la contraseña vigente de `root`.
3. Crea un respaldo dentro de `respaldos/`.
4. Aplica la migración del segundo avance.
5. Actualiza procedimientos, funciones, triggers, vistas y permisos.

La migración debe ejecutarse una sola vez. Esta operación:

- Agrega los hashes de los agentes.
- Cifra los correos existentes.
- Elimina la columna de correo legible de prospectos.
- Agrega la cuenta de conexión a la auditoría.
- Conserva los registros creados durante el primer avance.
- Bloquea la cuenta anterior `norteleads_app`.

Los registros antiguos de auditoría utilizan el valor `NO_REGISTRADO_AVANCE_1`, ya que la cuenta de conexión no se almacenaba durante el primer corte.

## Servicios y puertos

| Servicio | Dirección |
| --- | --- |
| Aplicación PHP | [http://localhost:8082](http://localhost:8082) |
| phpMyAdmin | [http://localhost:8081](http://localhost:8081) |
| MariaDB desde Workbench | `127.0.0.1:3307` |
| MariaDB dentro de Docker | `db:3306` |

## Conexión desde MySQL Workbench

Utiliza los siguientes datos:

| Campo | Valor |
| --- | --- |
| Connection Method | `Standard TCP/IP` |
| Hostname | `127.0.0.1` |
| Port | `3307` |
| Default Schema | `norte_leads` |

## Usuarios de demostración

| Usuario | Contraseña local | Rol |
| --- | --- | --- |
| `admin_nl` | `AdminNL_2026*Demo` | Administración de los datos de NorteLeads. |
| `agente_nl` | `AgenteNL_2026*Demo` | Seguimientos, lectura operativa y cambios de estado. |
| `consulta_nl` | `ConsultaNL_2026*Demo` | Lectura exclusiva de la vista enmascarada. |

Para una instalación nueva, la contraseña local de `root` es:

```text
RootNL_2026*Demo
```

Si se reutiliza el volumen del primer avance, se conserva la contraseña que ya tenía `root`. Modificar `MARIADB_ROOT_PASSWORD` en Docker Compose no cambia la contraseña almacenada dentro de un volumen existente.

Estas credenciales pertenecen únicamente al laboratorio académico y utilizan información ficticia.

## Procedimientos almacenados

El proyecto implementa tres procedimientos:

### `sp_listar_prospectos_negocio`

Recibe el identificador de un negocio mediante un parámetro `IN`, valida que exista y devuelve sus prospectos con el agente asignado.

### `sp_contar_prospectos`

Recibe el identificador del negocio mediante `IN` y devuelve la cantidad de prospectos mediante un parámetro `OUT`.

### `sp_registrar_intento`

Recibe los datos de un seguimiento y utiliza un parámetro `INOUT` para incrementar el número del intento. También inserta la interacción en la tabla `seguimientos`.

Los procedimientos utilizan `SIGNAL` para rechazar negocios inexistentes, identificadores inválidos y resúmenes vacíos.

## Funciones

### `fn_total_seguimientos`

Cuenta los seguimientos asociados con un prospecto y devuelve el total dentro de una consulta `SELECT`.

### `fn_email_prospecto`

Recupera de forma autorizada el correo cifrado de un prospecto. Esta función solo puede ser ejecutada por el rol administrativo.

## Triggers

### `trg_prospecto_auditar_estado`

Se ejecuta después de actualizar un prospecto. Si el estado cambia, registra:

- Estado anterior.
- Estado nuevo.
- Fecha del cambio.
- Cuenta que originó la conexión.
- Cuenta definidora del trigger.

### `trg_seguimiento_validar_resumen`

Se ejecuta antes de insertar un seguimiento. Rechaza resúmenes vacíos y elimina los espacios exteriores mediante `TRIM`.

## Vistas

### `vw_prospectos_negocio`

Relaciona prospectos, negocios y agentes mediante `INNER JOIN`. Facilita la consulta de información operativa.

### `vw_prospectos_publico`

Muestra nombres y teléfonos parcialmente ocultos. El usuario `consulta_nl` puede consultar esta vista, pero no tiene acceso directo a la tabla `prospectos`.

## Seguridad

La seguridad se divide en tres roles:

- `rol_admin_nl`
- `rol_agente_nl`
- `rol_consulta_nl`

Cada cuenta tiene un rol predeterminado. Para comprobar la identidad y el rol activo se puede ejecutar:

```sql
SELECT USER(), CURRENT_USER(), CURRENT_ROLE();
```

Las pruebas incluyen una operación permitida y una operación denegada para cada usuario.

## Hash de contraseñas

Las contraseñas ficticias de aplicación almacenadas en `agentes.clave_hash` utilizan bcrypt con sal aleatoria.

La demostración puede ejecutarse desde WSL:

```bash
docker compose exec -T app php /var/www/html/scripts/hash_demo.php
```

El script genera dos hashes diferentes para una misma contraseña y utiliza `password_verify` para aceptar la clave correcta y rechazar una incorrecta.

Estos hashes corresponden a futuras cuentas de la aplicación y son diferentes de las cuentas utilizadas para conectarse directamente a MariaDB.

## Cifrado de correos

Los correos de los prospectos se almacenan mediante AES-256-CBC. Cada registro utiliza:

- Una columna `email_cifrado`.
- Un vector de inicialización de 16 bytes en `email_iv`.
- Una clave local montada únicamente en el servicio `db`.

La clave no está publicada en el repositorio. El rol administrador puede recuperar el correo mediante `fn_email_prospecto`; los roles de agente y consulta no tienen ese permiso.

## Política de contraseñas

MariaDB carga el complemento `simple_password_check` y exige:

- Mínimo doce caracteres.
- Al menos un número.
- Al menos una letra mayúscula.
- Al menos una letra minúscula.
- Al menos un carácter especial.

La configuración está definida en `config/mariadb.cnf`. La política se aplica al crear o modificar contraseñas.

## Ejecución de pruebas

Las pruebas generales se encuentran en:

```text
sql/pruebas.sql
```

Las pruebas de permisos se encuentran en:

```text
sql/pruebas_usuarios.sql
```

Algunos bloques producen errores deliberadamente para demostrar las validaciones mediante `SIGNAL` y la separación de privilegios.

Las evidencias obtenidas se encuentran en la carpeta:

```text
evidencias/
```

## Informe

El informe final del segundo avance está disponible en:

```text
docs/Avance2_Roman_Antoine.pdf
```

El documento incluye la descripción del proyecto, el modelo de datos, los procedimientos, las funciones, los triggers, las vistas, la matriz de seguridad y las evidencias de ejecución.

## Video de sustentación

[Ver video del segundo avance](https://www.loom.com/share/bc72e2653a144b59bde648fed450bd8d)

## Versión del segundo avance

La versión correspondiente a esta entrega está identificada mediante la etiqueta:

```text
avance-2
```