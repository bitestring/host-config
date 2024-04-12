# Personal workstation setup - Fedora Silverblue

Personal scripts and Ansible playbooks for configuring a fresh Fedora Silverblue installation

## Step 1 - Update operating system:

    $ rpm-ostree upgrade

and reboot.

## Step 2 - Install pip and RPMFusion:

    $ rpm-ostree install pip https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

and reboot.

## Step 3 - Install Ansible:

    $ pip install --user ansible

## Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

## Step 5 - Install essential repositories and other prerequisites:

Execute the `system-ostree-pre.yml` playbook to remove locally pinned repos and install unpinned rpm-fusion

    $ ansible-playbook system-ostree-pre.yml

and reboot.

## Step 6 - Install system packages:

Execute the `system-*.yml` playbook to install core system tools like drivers, shells, virt-manager etc.

    $ ansible-playbook system-ostree.yml

and reboot.

## Step 7 - Configure system and services:

> Note: Before running this playbook you should have rebooted the system to ensure all installed services and users are available.

This playbook applies custom configurations, enables systemd services and other customizations.

    $ ansible-playbook --ask-become-pass system-config.yml

## Step 8 - Install userland apps

Execute `apps.yml` playbook to install userland applications like Firefox, LibreOffice, VLC etc. from Flathub primarily.

    $ ansible-playbook apps.yml

Now enjoy Fedora!
