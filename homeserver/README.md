# Homeserver setup

Playbook for installing basic system packages on a RHEL-compatible server, such as AlmaLinux, on a Raspberry Pi (tested on AlmaLinux).

# Install basic packages

### Step 1 - Update operating system:

```
sudo dnf offline-upgrade download
sudo dnf offline-upgrade reboot
```

### Step 2 - Install pip:

    $ sudo dnf install pip

### Step 3 - Install Ansible:

    $ pip install --user ansible

### Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

### Step 5 - Install system packages:

Execute the `system-dnf.yml` playbook to install core system tools like drivers, monitoring tools etc.

    $ ansible-playbook --ask-become-pass system-dnf.yml

and reboot.

# System configuration

> Note: Before running this playbook you should have rebooted the system to ensure all installed services and users are available.

This playbook applies custom configurations, enables systemd services and other customizations.

    $ ansible-playbook --ask-become-pass system-config.yml

# Apply custom config.txt settings for Raspberry Pi:

Manually tweak changes to `/boot/config.txt`. Refer `./pi-custom-config.txt` for reference.

# Other manual configuration

## Review Firewall config

Manually review firewall configuration to ensure it is secure.

Review if network interfaces are correctly attached to appropriate zones. Block all services and ports on **public** zone and allow only required services and ports on **home** zone.

On **firewalld** current configuration can be shown with

```
$ sudo firewall-cmd --list-all-zones
```

```
$ sudo firewall-cmd --list-services --zone=public
```

```
$ sudo firewall-cmd --list-ports --zone=public
```

```
$ sudo firewall-cmd --get-default-zone
```
