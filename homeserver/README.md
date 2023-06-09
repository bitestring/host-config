## Home Server

This playbook configures my home server (Fedora Server).

## Step 1 - Update operating system:

    $ sudo dnf upgrade

and reboot.

## Step 2 - Install Ansible:

    $ sudo dnf install ansible

## Step 3 - Install Ansible Collections:

Navigate to the directory where you've cloned this repository and execute following command to install Ansible Collections from `requirements.yml`.

    $ ansible-galaxy collection install -r requirements.yml

## Step 4 - Install packages and configure system:

Execute the `system-*.yml` playbook to install core system tools like container tools, shells etc and configur systemd services.

    $ ansible-playbook --ask-become-pass system-server.yml

and reboot.
