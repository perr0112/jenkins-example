#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:3000}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-15}"
SLEEP_SECONDS="${SLEEP_SECONDS:-2}"
CONTAINER_NAME="${CONTAINER_NAME:-task-api-local}"

echo "[smoke] Vérification de ${BASE_URL}/health"
attempt=1
HEALTH=""
while [ "${attempt}" -le "${MAX_ATTEMPTS}" ]; do
  if HEALTH="$(curl -fsS "${BASE_URL}/health" 2>/dev/null)"; then
    break
  fi
  echo "[smoke] attente service (${attempt}/${MAX_ATTEMPTS})..."
  sleep "${SLEEP_SECONDS}"
  attempt=$((attempt + 1))
done

if [ -z "${HEALTH}" ]; then
  echo "[smoke] KO: service inaccessible sur ${BASE_URL}"
  if docker container inspect "${CONTAINER_NAME}" >/dev/null 2>&1; then
    echo "[smoke] Derniers logs du conteneur ${CONTAINER_NAME}:"
    docker logs --tail 50 "${CONTAINER_NAME}" || true
  fi
  exit 1
fi

case "${HEALTH}" in
  *"\"status\":\"ok\""*) ;;
  *)
    echo "[smoke] KO: endpoint /health inattendu: ${HEALTH}"
    exit 1
    ;;
esac

echo "[smoke] Vérification de ${BASE_URL}/api/tasks"
TASKS="$(curl -sS "${BASE_URL}/api/tasks")"
case "${TASKS}" in
  *"\"tasks\""*) ;;
  *)
    echo "[smoke] KO: endpoint /api/tasks inattendu: ${TASKS}"
    exit 1
    ;;
esac

echo "[smoke] OK"