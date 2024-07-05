#!/bin/bash
set -euo pipefail

if bluetoothctl show | grep 'Powered: no'; then
	until bluetoothctl power on; do sleep 0.1; done
else
	until bluetoothctl power off; do sleep 0.1; done
fi
