# Personal workstation setup

Ansible playbooks for configuring a stock Fedora Silverblue installation

# Install basic packages

## Fedora Silverblue

### Step 1 - Update operating system:

    $ sudo rpm-ostree upgrade

and reboot.

### Step 2 - Install pip and RPMFusion:

    $ sudo rpm-ostree install pip https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

and reboot.

Reference: https://rpmfusion.org/Configuration

### Step 3 - Install Ansible:

    $ pip install --user ansible

### Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

### Step 5 - Install essential repositories and other prerequisites:

Execute the `system-ostree-pre.yml` playbook to remove locally pinned repos and install unpinned rpm-fusion

    $ ansible-playbook --ask-become-pass system-ostree-pre.yml

and reboot.

### Step 6 - Install system packages:

Execute the `system-ostree.yml` playbook to install core system tools like drivers, monitoring tools, hypervisor etc.

    $ ansible-playbook --ask-become-pass system-ostree.yml

and reboot.

## Fedora Workstation

Ansible playbooks for configuring a stock Fedora Workstation installation

### Step 1 - Update operating system:

```
sudo dnf offline-upgrade download
sudo dnf offline-upgrade reboot
```

### Step 2 - Install pip and RPMFusion:

    $ sudo dnf install pip

### Step 3 - Install Ansible:

    $ pip install --user ansible

### Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

### Step 5 - Install system packages:

Execute the `system-dnf.yml` playbook to install core system tools like drivers, monitoring tools, hypervisor etc.

    $ ansible-playbook --ask-become-pass system-dnf.yml

and reboot.

# System configuration

> Note: Before running this playbook you should have rebooted the system to ensure all installed services and users are available.

This playbook applies custom configurations, enables systemd services and other customizations.

    $ ansible-playbook --ask-become-pass system-config.yml

# Apps Installation

Execute `apps.yml` playbook to install userland applications like Firefox, LibreOffice, VLC etc. from Flathub primarily.

    $ ansible-playbook apps.yml

Now enjoy Fedora!
