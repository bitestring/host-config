Ansible Playbooks, Nix Flakes and other scripts to provision my personal workstation and servers with apps and custom configuration.

> Note: All the guides in the repository assume that the host has cloned this repo using `git` or other methods.

# Ansible Guide

Install Ansible:

```
pip install --user ansible
```

## Install Ansible Collections:

```
ansible-galaxy collection install -r requirements.yml
```

## Run a Playbook

```
ansible-playbook --ask-become-pass <Playbook.yml>
```

# Manual Configurations

Some manual configurations and tweaks have been documented in [MANUAL_CONFIG.md](./MANUAL_CONFIG.md).

# License

The source code is licensed under the [GNU Affero General Public License Version 3](https://www.gnu.org/licenses/agpl-3.0.txt). A copy of the GNU AGPL V3.0 can be found in this repository under the filename [LICENSE](./LICENSE).

# References

https://docs.ansible.com/ansible/latest/collections/index.html
