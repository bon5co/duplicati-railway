#!/bin/bash
# Railway boot for Duplicati.
#
# Upstream's server reads DUPLICATI__WEBSERVICE_PASSWORD at every start and SETTINGS_ENCRYPTION_KEY to encrypt the stored settings
# (backup passphrases, destination credentials). This script makes both mandatory, refuses a short password, listens on Railway's
# injected PORT, accepts any Host header (upstream answers sign-in 403 from a hostname outside its allowlist), and creates the two folders the web UI offers as defaults.
set -u
: "${PORT:=8080}"
if [ -z "${DUPLICATI__WEBSERVICE_PASSWORD:-}" ]; then
  echo "[railway] DUPLICATI__WEBSERVICE_PASSWORD is not set; refusing to start a backup server without a login" >&2
  exit 1
fi
if [ "${#DUPLICATI__WEBSERVICE_PASSWORD}" -lt 8 ]; then
  echo "[railway] DUPLICATI__WEBSERVICE_PASSWORD must be at least 8 characters" >&2
  exit 1
fi
if [ -z "${SETTINGS_ENCRYPTION_KEY:-}" ]; then
  echo "[railway] SETTINGS_ENCRYPTION_KEY is not set; refusing to store backup credentials unencrypted" >&2
  exit 1
fi
export DUPLICATI__WEBSERVICE_PORT="$PORT"
export DUPLICATI__WEBSERVICE_INTERFACE=any
export DUPLICATI__WEBSERVICE_ALLOWED_HOSTNAMES="${DUPLICATI__WEBSERVICE_ALLOWED_HOSTNAMES:-*}"
mkdir -p /data/backups /data/source
echo "[railway] Duplicati on :$PORT, settings encrypted, data under /data (database /data/Duplicati, local backups /data/backups)"
exec /run-as-user.sh "$@"
