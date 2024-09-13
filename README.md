# VPS Setup Hestia
A cloud init script for provisioning a VPS with HestiaCP 

#VPS Setup Script
This repository contains a Bash script to automate the setup of a new VPS (Virtual Private Server) running on Ubuntu. It installs essential software, configures Zsh and Bash shells, adds custom aliases, environment variables, functions, and allows the user to choose additional software to install.

##Features
 - Zsh and Oh My Zsh Setup: Installs Zsh and the popular Oh My Zsh framework for managing Zsh configuration.
 - Custom Aliases: Adds a set of useful aliases to both .bashrc and .zshrc.
 - Environment Variables: Adds predefined environment variables to both .bashrc and .zshrc.
 - Custom Functions: Includes useful shell functions for directory management, system updates, and file extraction.
 - Optional Software Installation: Provides an interactive menu for the user to install additional software like Docker, Node.js, and Python 3.10.
 - DigitalOcean and Cloudflare CLI Installations: Installs doctl for DigitalOcean management and cloudflared for Cloudflare CLI.
 - direnv Setup: Installs and configures direnv for managing environment variables.

##Prerequisites
 - doctl Installed on your local machine


##Installation

NOTE: To get the fingerprints of your SSH keys from Digital Ocean, run this command:
`doctl compute ssh-key list`

To create the new droplet, run this command in the CLI
`doctl compute droplet create <dropletname> --image ubuntu-22-04-x64 --size s-1vcpu-1gb --region nyc1 --ssh-keys <fingerprint>  --user-data-file cloud-init.yaml  --wait --enable-monitoring`

This will run the following cloud init script

```yaml
#cloud-config
users:
  - name: newuser    # Replace 'newuser' with your desired username
    sudo: ['ALL=(ALL) NOPASSWD:ALL']  # Grants sudo privileges without a password prompt
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-rsa AAAAB3Nza...    # Replace with the actual public SSH key from DigitalOcean's stored keys

package_update: true  # Update the package lists
package_upgrade: true  # Upgrade all packages

packages:
  - software-properties-common
  - wget
  - curl
  - mc
  - build-essential
  - file
  - git
  - git-core

runcmd:
  - wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
  - chmod +x hst-install.sh
  
  # Create directory and run the setup script as the new user
  - sudo -u newuser mkdir -p /home/newuser/install
  - sudo -u newuser bash -c 'cd /home/newuser/install && curl -fsSL https://raw.githubusercontent.com/alchemizt/vps_setup_hestia/main/setup.sh -o setup.sh && chmod +x setup.sh && sudo bash ./setup.sh'

```

After it is complete, ssh to root@ip-addr. And run the HestiaCP installer.

`./hcp-install.sh`


Contributing
Feel free to fork this repository, make changes, and submit a pull request. Any contributions, such as adding more software options or improving the script, are welcome!

License
This project is licensed under the MIT License - see the LICENSE file for details.