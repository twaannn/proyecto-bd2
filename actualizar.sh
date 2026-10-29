#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bash preparar.sh
docker compose up -d --build --wait
read -r -s -p "Contrasena root ACTUAL (la del primer corte): " NL_ROOT_PASSWORD
echo
mkdir -p respaldos
backup="respaldos/antes_avance2_$(date +%Y%m%d_%H%M%S).sql"
docker compose exec -T -e MYSQL_PWD="$NL_ROOT_PASSWORD" db mariadb-dump -u root --single-transaction norte_leads > "$backup"
echo "Respaldo creado en $backup"
for archivo in actualizar_avance2 procedimientos funciones triggers vistas seguridad; do
  echo "Aplicando sql/$archivo.sql"
  docker compose exec -T -e MYSQL_PWD="$NL_ROOT_PASSWORD" db mariadb -u root norte_leads < "sql/$archivo.sql"
done
unset NL_ROOT_PASSWORD
echo "Actualizacion terminada. No se borraron tablas ni se repitieron los datos de prueba."
