# Homeserver setup

Playbook for installing basic system packages on a RHEL-compatible server, such as AlmaLinux, on a Raspberry Pi (tested on AlmaLinux 10).

# WARNING

**DO NOT CONNECT THE SERVER TO AN UNTRUSTED NETWORK. MAKE SURE THE NETWORK IS PROTECTED BEHIND A TRUSTED EXTERNAL ROUTER/FIREWALL LIKE OPENWRT OR OPNSENSE BEFORE TRAFFIC REACHES THE SERVER.**

This homeserver setup assumes there's a trusted router like [OpenWrt](https://openwrt.org/) or [OPNsense](https://opnsense.org/) with proper firewall configuration protecting the home network. Connecting the server to an untrusted or outdated routers can put the data at risk.

# Install basic packages

### Step 1 - Update operating system:

```
sudo dnf offline-upgrade download
```

```
sudo dnf offline-upgrade reboot
```

### Step 2 - Install pip:

```
sudo dnf install pip
```

### Step 3 - Install Ansible:

```
pip install --user ansible
```

### Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

```
ansible-galaxy collection install -r requirements.yml
```

### Step 5 - Install system packages:

Execute the `system-dnf.yml` playbook to install core system tools like drivers, monitoring tools etc.

```
ansible-playbook --ask-become-pass system-dnf.yml
```

and reboot.

# System configuration

> Note: Before running this playbook you should have rebooted the system to ensure all installed services and users are available.

This playbook applies custom configurations, enables systemd services and other customizations.

```
ansible-playbook --ask-become-pass system-config.yml
```

# Apply custom config.txt settings for Raspberry Pi:

Manually tweak changes to `/boot/config.txt`. Refer `./pi-custom-config.txt` for reference.

# References

https://almalinux.org/

https://podman.io/
