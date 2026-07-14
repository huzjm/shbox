#!/usr/bin/env bash
set -euo pipefail

export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority
export SHBOX_SERVER_URL="${SHBOX_SERVER_URL:-http://localhost:5051}"
export SHBOX_DEVICE_ID="${SHBOX_DEVICE_ID:-sakina-shbox}"

cd /home/pi/SHbox/frontend/mobile_app
flutter run -d linux --release
