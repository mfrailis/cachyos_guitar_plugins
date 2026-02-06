#!/usr/bin/env bash
set -euo pipefail

echo "Applying audio performance tuning..."

# CPU performance scaling
echo "- Setting CPU governor to performance..."
powerprofilesctl set performance

# Disable SMT
echo "- Disabling SMT..."
echo off > /sys/devices/system/cpu/smt/control

# Adjust swap behavior
echo "- Setting swappiness to 10..."
sysctl -w vm.swappiness=10

# Disable USB autosuspend
echo "- Disabling USB autosuspend..."
echo -1 > /sys/module/usbcore/parameters/autosuspend

echo "✓ Audio tuning applied successfully"
