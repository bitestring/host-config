# Personal workstation setup - Fedora IoT or any Atomic variant

Ansible playbooks for configuring a fresh Fedora IoT or any Atomic based server

## Step 1 - Update operating system:

    $ rpm-ostree upgrade

and reboot.

## Step 2 - Install pip:

    $ rpm-ostree install pip

and reboot.

## Step 3 - Install Ansible:

    $ pip install --user ansible

## Step 4 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

## Step 5 - Install system packages:

Execute the `system-*.yml` playbook to install core system tools like Docker, Cockpit etc.

    $ ansible-playbook system-ostree.yml

and reboot.

## Step 6 - Configure system and services:

> Note: Before running this playbook you should have rebooted the system to ensure all installed services and users are available.

This playbook applies custom configurations, enables systemd services and other customizations.

    $ ansible-playbook --ask-become-pass system-config.yml

Now enjoy Fedora!
