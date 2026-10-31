#!/bin/sh
set -eu

# Fail closed before the HTTP listener exists. Never print credential values.
MOCKTAIL_ADMIN_KEY=${MOCKTAIL_ADMIN_KEY:-}
MOCKTAIL_API_KEY=${MOCKTAIL_API_KEY:-}
if [ "${#MOCKTAIL_ADMIN_KEY}" -lt 32 ] || [ "${#MOCKTAIL_API_KEY}" -lt 32 ]; then
    echo 'Set distinct MOCKTAIL_ADMIN_KEY and MOCKTAIL_API_KEY secrets (at least 32 characters each) before deploying.' >&2
    exit 78
fi
if [ "$MOCKTAIL_ADMIN_KEY" = "$MOCKTAIL_API_KEY" ]; then
    echo 'The management and mock API keys must be different.' >&2
    exit 78
fi

# This pilot has no paid AI dependency and does not accept an outbound AI gateway.
env | while IFS='=' read -r name value; do
    case "$name" in
        MOCKTAIL_AI_API_KEY*|MOCKTAIL_AI_BASE_URL*)
            if [ -n "$value" ]; then
                echo 'Remove AI keys and gateway overrides for this pilot.' >&2
                exit 78
            fi
            ;;
    esac
done

# Bound retained logs; these are not a substitute for the platform memory limit.
export MOCKTAIL_LOG_BUFFER_MB=8 MOCKTAIL_LOG_BODY_KB=8
export GOMEMLIMIT=160MiB GOMAXPROCS=1
export MOCKTAIL_DB_PATH=/db/apis.db MOCKTAIL_PORT=6625
# Keep optional AI settings/key storage outside the persistent SQLite volume.
export XDG_CONFIG_HOME=/tmp/mocktail-config
exec /app
