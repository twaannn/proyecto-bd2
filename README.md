# NorteLeads

## Avance 2 de Bases de Datos II

Base de datos para organizar la atención comercial de microempresas de Cartago y el norte del Valle del Cauca. Registra negocios, prospectos, agentes, seguimientos, citas, planes, suscripciones, pagos y cambios de estado.

El proyecto utiliza MariaDB 11.4, PHP 8.3 y phpMyAdmin en Docker. Incluye diez tablas, tres procedimientos con parámetros IN, OUT e INOUT y validaciones SIGNAL, dos funciones, dos triggers, dos vistas y tres roles con sus usuarios.

## Archivos

| Ruta | Contenido |
| --- | --- |
| `docker-compose.yml` | Servicios, puertos, volumen e inicialización SQL. |
| `Dockerfile` e `index.php` | Aplicación PHP que consulta la vista enmascarada. |
| `sql/esquema.sql` | Diez tablas, claves y restricciones. |
| `sql/datos_prueba.sql` | Datos ficticios, correos cifrados y hashes bcrypt. |
| `sql/procedimientos.sql` | Listar, contar y registrar intentos. |
| `sql/funciones.sql` | Contar seguimientos y recuperar un correo para el administrador. |
| `sql/triggers.sql` | Auditoría de cambios y validación del resumen. |
| `sql/vistas.sql` | Vista con JOIN y vista con datos enmascarados. |
| `sql/seguridad.sql` | Roles, usuarios y privilegios. |
| `sql/actualizar_avance2.sql` | Migración de la base del primer corte. |
| `sql/pruebas.sql` | Pruebas funcionales para ejecutar por bloques. |
| `sql/pruebas_usuarios.sql` | Pruebas permitidas y denegadas por usuario. |
| `sql/video.sql` | Consultas breves del video. |
| `config/mariadb.cnf` | Política de contraseñas y directorio del secreto. |
| `modelado/mer.mwb` | Modelo actualizado para MySQL Workbench. |
| `docs/` | Informe, guion del video y explicación del código. |

## Instalación sobre una base nueva

En WSL, dentro de la carpeta que contiene `docker-compose.yml`:

```bash
bash preparar.sh
docker compose up -d --build --wait
docker compose ps
```

`preparar.sh` crea una clave aleatoria local para cifrar correos. Conservar `secrets/clave_cifrado.txt` junto con el respaldo de la base; se excluye de Git y del contexto de construcción de Docker. No se necesitan archivos `.env`.

Los siete scripts montados en Compose se ejecutan automáticamente cuando MariaDB encuentra un volumen vacío. No ejecutar nuevamente `esquema.sql` ni `datos_prueba.sql` sobre una base que ya tenga registros.

## Actualización de la base del primer corte

Copiar los archivos del avance a la carpeta del repositorio existente, conservando su carpeta `.git`. Mantener el nombre de carpeta/proyecto Compose para reutilizar su volumen. Ejecutar:

```bash
bash actualizar.sh
```

El script levanta el entorno, pide la contraseña root actual, crea un respaldo en `respaldos/` y aplica la migración y las definiciones nuevas. En el Compose del primer corte la contraseña root predeterminada era `root_demo_2026`; si fue modificada, usar la vigente. Cambiar el valor de `MARIADB_ROOT_PASSWORD` en Compose no modifica la contraseña de un volumen existente.

La migración se ejecuta **una sola vez**: cifra los correos existentes y elimina su columna legible, añade los hashes y la cuenta de conexión a la auditoría. Conserva las filas y no repite los datos de prueba. Los registros antiguos de auditoría muestran `NO_REGISTRADO_AVANCE_1` en la nueva columna. La cuenta anterior `norteleads_app` queda bloqueada; las conexiones usan las cuentas siguientes.

## Accesos locales de demostración

Host Workbench: `127.0.0.1`; puerto: `3307`; esquema: `norte_leads`. En phpMyAdmin, servidor `db`.

| Usuario | Contraseña local | Rol |
| --- | --- | --- |
| `admin_nl` | `AdminNL_2026*Demo` | Administración de los datos de NorteLeads; no administra el servidor. |
| `agente_nl` | `AgenteNL_2026*Demo` | Rutinas de seguimiento, lectura operativa y cambio de estado. |
| `consulta_nl` | `ConsultaNL_2026*Demo` | Lectura de la vista enmascarada. |

En una instalación nueva, root usa `RootNL_2026*Demo`. Son credenciales públicas del laboratorio con datos ficticios; deben sustituirse para un despliegue real.

- Aplicación: <http://localhost:8080>
- phpMyAdmin: <http://localhost:8081>

Cada cuenta tiene un rol predeterminado. Para probar la seguridad, abrir conexiones diferentes en Workbench y comprobar `SELECT USER(), CURRENT_ROLE();`.

## Pruebas

1. Abrir `sql/pruebas.sql` con `admin_nl`. Ejecutar los bloques de manera individual: algunos producen errores deliberadamente.
2. Abrir `sql/pruebas_usuarios.sql` y ejecutar cada grupo en la conexión del usuario indicado.
3. Comprobar hash con sal en WSL:

```bash
docker compose exec -T app php /var/www/html/scripts/hash_demo.php
```

Los hashes de `agentes.clave_hash` utilizan bcrypt con sal incluida. Son contraseñas de aplicación de prueba, distintas de las cuentas de acceso a MariaDB. El correo de cada prospecto se guarda en `email_cifrado` con AES-256-CBC y un IV de 16 bytes por registro; la clave se monta únicamente en el servicio `db`. El rol administrador puede ejecutar `fn_email_prospecto`; los otros dos roles no reciben ese permiso.

## Política de contraseñas

MariaDB carga `simple_password_check` al iniciar. Exige mínimo doce caracteres, un número, una mayúscula, una minúscula y un carácter especial. La configuración persiste en `config/mariadb.cnf`; `strict_password_validation` permanece activo. Las cuentas nuevas del laboratorio cumplen esa regla. La política valida contraseñas nuevas o modificadas, no cambia automáticamente una contraseña anterior.

## Informe y sustentación

El informe está en `docs/Avance2_Roman_Antoine.pdf`, con copia editable en Word. Completar el programa académico, el enlace público del video, la exportación del MER y las capturas obtenidas en el Docker del estudiante. `docs/paso_a_paso.md` indica cómo obtenerlas; `docs/guion_video.md` organiza un video de hasta cinco minutos. Las explicaciones para estudiar están en `docs/explicacion_codigo.md`.

## Etiqueta del repositorio

Después de incorporar el informe final y las evidencias, desde el repositorio existente:

```bash
git add .
git commit -m "Avance 2 - segundo corte"
git tag avance-2
git push origin master --tags
```

La rama del repositorio de referencia es `master`. Comprobar `git branch --show-current` antes de publicar. No crear de nuevo una etiqueta que ya exista.


## Video de sustentación

[Ver video del segundo avance](https://www.loom.com/share/bc72e2653a144b59bde648fed450bd8d)