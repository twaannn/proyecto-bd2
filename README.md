# NorteLeads - Base de datos para seguimiento comercial

Proyecto de **Bases de Datos II** para negocios de Cartago y el norte del Valle del Cauca. NorteLeads permite registrar los prospectos que contactan a cada negocio, asignarles un agente, guardar los seguimientos y programar citas. También registra los planes, las suscripciones y los pagos.

La base tiene diez tablas relacionadas. Incluye datos de prueba, tres procedimientos almacenados y un trigger que guarda los cambios de estado de los prospectos en una tabla de auditoría.

## Estructura del proyecto

```text
norte_leads_db/
├── docs/
│   └── informe_avance.pdf
├── modelado/
│   └── mer.mwb
├── sql/
│   ├── esquema.sql
│   ├── datos_prueba.sql
│   ├── procedimientos.sql
│   └── triggers.sql
├── .gitignore
├── docker-compose.yml
├── Dockerfile
└── README.md
```

## Contenido de la entrega

| Archivo | Descripción |
| --- | --- |
| `docs/informe_avance.pdf` | Informe del proyecto y evidencias de ejecución. |
| `sql/esquema.sql` | Creación de la base de datos, las tablas y sus relaciones. |
| `sql/datos_prueba.sql` | Registros de prueba para comprobar la base de datos. |
| `sql/procedimientos.sql` | Definición de los procedimientos almacenados. |
| `sql/triggers.sql` | Definición del trigger de auditoría. |
| `modelado/mer.mwb` | Modelo de la base de datos editable en MySQL Workbench. |
| `.gitignore` | Archivos que se excluyen de Git. |
| `docker-compose.yml` | Configuración de los contenedores del proyecto. |
| `Dockerfile` | Instrucciones para construir el contenedor de la aplicación. |

## Requisitos

- Docker con Docker Compose.
- MySQL Workbench para consultar la base y abrir el modelo `.mwb`.

## Cómo ejecutarlo

1. Abrir una terminal en la carpeta `norte_leads_db` y levantar los contenedores:

```bash
docker compose up -d --build
docker compose ps
```

2. Comprobar que los servicios aparecen en ejecución con `docker compose ps`. Abrir phpMyAdmin en <http://localhost:8081> para revisar la base de datos. Las conexiones y sus puertos se definen en `docker-compose.yml`.

3. En MySQL Workbench, conectarse a MariaDB. En la configuración usada para este proyecto, la conexión es a `127.0.0.1` por el puerto `3307`; el usuario y la contraseña están definidos en `docker-compose.yml`.

4. Si la base de datos está vacía, abrir y ejecutar estos archivos en Workbench, **uno por uno y en este orden**:

1. `sql/esquema.sql`
2. `sql/procedimientos.sql`
3. `sql/triggers.sql`
4. `sql/datos_prueba.sql`

El trigger se crea antes de insertar los datos para que los cambios de estado registrados por `datos_prueba.sql` queden en la tabla de auditoría. Si la base ya contiene los registros, no ejecutes de nuevo `datos_prueba.sql`.

5. Para comprobar que se crearon las tablas y se cargaron los datos, ejecutar en Workbench:

```sql
USE norte_leads;
SHOW TABLES;
SELECT COUNT(*) AS total_prospectos FROM prospectos;
SELECT * FROM auditoria_prospectos;
```

6. Abrir `modelado/mer.mwb` con MySQL Workbench para mostrar el modelo de la base de datos. El desarrollo del proyecto y sus evidencias se encuentran en `docs/informe_avance.pdf`.
