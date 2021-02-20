#!/usr/bin/env sh
set -eu

envsubst '${SRT_RELAY_SERVER}' < /ffmpeg.sh.template > /ffmpeg.sh
chmod +x /ffmpeg.sh

exec "$@"