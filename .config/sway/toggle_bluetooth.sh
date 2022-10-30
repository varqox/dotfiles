#!/bin/bash
set -e

bluetooth | grep "= on" && until bluetoothctl power on; do sleep 0.1; done
