#!/bin/bash
# File: /usr/local/bin/qapkyy_qy-init.sh
# Purpose: Initialize sysfs runtime parameters and group permissions for qapkyy_qy driver

MODNAME="qapkyy_qy"
GROUPNAME="nitro_sense"

echo "Initializing driver configuration for ${MODNAME}..."

BASE_PATH=$(find /sys/devices/platform -name "${MODNAME}" -type d | head -n 1)

if [ -z "$BASE_PATH" ] || [ ! -d "$BASE_PATH" ]; then
    echo "CRITICAL: Sysfs entry path for ${MODNAME} could not be discovered. Exiting."
    exit 1
fi

echo "Discovered hardware driver interface at: ${BASE_PATH}"

if [ -f "${BASE_PATH}/battery_limiter" ]; then
    echo 1 > "${BASE_PATH}/battery_limiter"
    echo "Success: Battery health limiter (80% charging threshold) has been applied."
else
    echo "Warning: battery_limiter node not found under the discovered path."
fi

echo "Configuring user-space control permissions for group: ${GROUPNAME}..."

if getent group "${GROUPNAME}" >/dev/null; then
    find "${BASE_PATH}" -type f \( -name "battery_limiter" -o -name "fan_speed" \) -exec chown root:${GROUPNAME} {} +
    find "${BASE_PATH}" -type f \( -name "battery_limiter" -o -name "fan_speed" \) -exec chmod 0660 {} +

    PP_PATH="/sys/firmware/acpi/platform_profile"
    if [ -f "$PP_PATH" ]; then
        chown root:${GROUPNAME} "$PP_PATH"
        chmod 0664 "$PP_PATH"
    fi
    echo "Runtime node rules established successfully."
else
    echo "Warning: Targeting group '${GROUPNAME}' does not exist. Skipping acl optimization."
fi

exit 0
