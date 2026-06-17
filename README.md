# Acer Nitro V16 — WMI Battery Health Control Driver

[![License: GPL-2.0-only](https://img.shields.io/badge/License-GPL--2.0--only-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![Linux Kernel](https://img.shields.io/badge/Linux-Kernel%20%E2%89%A5%206.1-red.svg)](https://kernel.org)
[![Hardware](https://img.shields.io/badge/Hardware-Acer%20Nitro%20V16%20ANV16--71-green.svg)]()

A lightweight Linux kernel WMI driver for controlling battery features on the **Acer Nitro V16 (ANV16-71)** laptop. This driver communicates with the laptop's ACPI firmware via WMI (Windows Management Instrumentation) interfaces to manage charge limits, battery calibration, and real-time internal temperature readings.

---

## Features

| Feature | Description |
|---|---|
| 🔋 **Battery Health Mode** | Caps charging to ~80% to extend long-term battery lifespan |
| 🔧 **Calibration Mode** | Enable/disable battery gauge calibration |
| 🌡️ **Temperature Monitoring** | Read real-time internal battery temperature (in milli-Celsius) |
| 📁 **Sysfs Interface** | Standard integration via the Linux `/sys` filesystem |
| ⚙️ **Module Parameter** | Set the default health mode behavior at boot via kernel arguments |

---

## Compatibility

- **Hardware:** Acer Nitro V16 series (tested on ANV16-71 variants)
- **Kernel:** Linux ≥ 6.1 — backwards compatible with kernels `< 6.12.0` and fully compliant with newer kernels

---

## Installation

### 1. Prerequisites

Make sure you have the required kernel headers and build tools installed.

**Ubuntu / Debian / Pop!_OS:**
```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r)
```

**Fedora:**
```bash
sudo dnf update
sudo dnf install kernel-devel kernel-headers development-tools
```

**Arch Linux:**
```bash
sudo pacman -S base-devel linux-headers
```

### 2. Clone and Compile

```bash
git clone https://github.com/Qapkyy/wmi-battery-acer.git
cd wmi-battery-acer
make
```

### 3. Load the Module (Temporary)

To test the module without a permanent install:

```bash
sudo insmod wmi-battery-acer.ko
```

To load the module with health mode enabled right away:

```bash
sudo insmod wmi-battery-acer.ko enable_health_mode=1
```

### 4. Permanent Installation (Optional)

To have the module load automatically on every boot:

```bash
sudo cp wmi-battery-acer.ko /lib/modules/$(uname -r)/kernel/drivers/platform/x86/
sudo depmod -a
echo "wmi-battery-acer" | sudo tee /etc/modules-load.d/wmi-battery-acer.conf
```

To permanently set a default health mode:

```bash
echo "options wmi-battery-acer enable_health_mode=1" | sudo tee /etc/modprobe.d/wmi-battery-acer.conf
```

---

## Usage

Once the driver is loaded, sysfs nodes will be available under:

```
/sys/bus/wmi/drivers/acer-wmi-battery/<device>/
```

### Reading Status

**Battery temperature** (in milli-Celsius):
```bash
cat /sys/bus/wmi/drivers/acer-wmi-battery/*/temperature
# Example output: 29800  →  29.8°C
```

**Health mode status** (`-1` = unsupported, `0` = disabled, `1` = enabled):
```bash
cat /sys/bus/wmi/drivers/acer-wmi-battery/*/health_mode
```

**Calibration mode status:**
```bash
cat /sys/bus/wmi/drivers/acer-wmi-battery/*/calibration_mode
```

### Changing Modes

**Enable health mode** (charge limit ~80%):
```bash
echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/*/health_mode
```

**Disable health mode** (charge to full 100%):
```bash
echo 0 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/*/health_mode
```

**Enable calibration mode:**
```bash
echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/*/calibration_mode
```

**Disable calibration mode:**
```bash
echo 0 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/*/calibration_mode
```

### Module Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `enable_health_mode` | `short` | `-1` | `> 0` = enable, `0` = disable, `< 0` = keep current setting |

---

## Unloading the Driver

To remove the module from the running kernel:

```bash
sudo rmmod wmi-battery-acer
```

---

## Troubleshooting

**Module fails to load (`ENODEV`):**
> The hardware was not recognized. Confirm your laptop is an Acer Nitro V16 ANV16-71 by running `sudo dmidecode -s system-product-name`.

**Sysfs path not found:**
> Locate the exact path with:
> ```bash
> find /sys/bus/wmi/drivers/acer-wmi-battery/ -name "health_mode"
> ```

**Permission denied when writing to sysfs:**
> Make sure you are using `sudo tee` instead of `sudo echo`. Redirection (`>`) does not carry root privileges.

---

## License

This driver is licensed under **GPL-2.0-only**. See [GNU GPL v2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) for full details.

---

## Author

**Qapky** — [qapkyy3@gmail.com](mailto:qapkyy3@gmail.com)

Contributions, bug reports, and pull requests are welcome!
