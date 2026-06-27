MODNAME := qapkyy_qy
obj-m   := src/$(MODNAME).o

KVER    ?= $(shell uname -r)
KDIR    := /lib/modules/$(KVER)/build
PWD     := $(shell pwd)

MDIR    := /lib/modules/$(KVER)/kernel/drivers/platform/x86
REAL_USER := $(shell echo $${SUDO_USER:-$$(whoami)})

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install: all
	@echo "Installing kernel module $(MODNAME)..."
	sudo cp $(MODNAME).ko $(MDIR)/
	sudo depmod -a

	@echo "Configuring automatic module loading at boot..."
	echo "$(MODNAME)" | sudo tee /etc/modules-load.d/$(MODNAME).conf > /dev/null

	@echo "Blacklisting conflicting native acer_wmi module..."
	echo "blacklist acer_wmi" | sudo tee /etc/modprobe.d/blacklist-acer_wmi.conf > /dev/null

	@echo "Setting up user group for hardware control access..."
	@if ! getent group nitro_sense >/dev/null; then \
		sudo groupadd nitro_sense; \
	fi
	sudo usermod -aG nitro_sense $(REAL_USER)

	@echo "Deploying systemd execution assets..."
	sudo mkdir -p /usr/local/bin
	sudo cp systemd/$(MODNAME)-init.sh /usr/local/bin/$(MODNAME)-init.sh
	sudo chmod +x /usr/local/bin/$(MODNAME)-init.sh

	@echo "Generating and injecting values into systemd service..."
	sed "s/\$$(MODNAME)/$(MODNAME)/g" systemd/$(MODNAME).service | sudo tee /etc/systemd/system/$(MODNAME).service > /dev/null

	sudo systemctl daemon-reload
	sudo systemctl enable $(MODNAME).service
	sudo systemctl start $(MODNAME).service
	@echo "Installation successful! Please reboot your system to clean-load the isolated driver."

uninstall:
	@echo "Stopping and removing systemd services..."
	sudo systemctl stop $(MODNAME).service 2>/dev/null || true
	sudo systemctl disable $(MODNAME).service 2>/dev/null || true
	sudo rm -f /etc/systemd/system/$(MODNAME).service
	sudo rm -f /usr/local/bin/$(MODNAME)-init.sh
	sudo systemctl daemon-reload

	@echo "Removing driver binaries, auto-loads, and blacklists..."
	sudo rm -f /etc/modules-load.d/$(MODNAME).conf
	sudo rm -f /etc/modprobe.d/blacklist-acer_wmi.conf
	sudo rm -f /etc/tmpfiles.d/$(MODNAME).conf
	sudo rm -f $(MDIR)/$(MODNAME).ko
	sudo depmod -a
	sudo rmmod $(MODNAME) 2>/dev/null || true

	@echo "Restoring stock system fallback modules..."
	sudo modprobe acer_wmi 2>/dev/null || true
	@echo "Uninstallation complete."
