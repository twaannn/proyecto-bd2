#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p secrets
chmod 700 secrets
if [ ! -s secrets/clave_cifrado.txt ]; then
  openssl rand -hex 32 > secrets/clave_cifrado.txt
  chmod 644 secrets/clave_cifrado.txt
  echo "Clave local de cifrado creada. Conserva este archivo fuera de Git."
else
  echo "Se conserva la clave de cifrado existente."
fi
