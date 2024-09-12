# hcp_cloud_init
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
 - A VPS running Ubuntu 22.04 or later.
 - Root or sudo access to the VPS.
 - Git must be installed on the VPS to clone this repository.


##Installation
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
  - sudo apt-get update
  - wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
  - sudo chmod +x hst-install.sh
  - su - newuser
  - mkdir ~/install && cd ~/install 
  - curl -fsSL https://raw.githubusercontent.com/alchemizt/hcp_cloud_init/main/setup.sh
  - chmod +x ./setup.sh
  - sudo bash ./setup.sh 
```


On creating your new Digital Ocean Droplet, add this cloud init script:


Contributing
Feel free to fork this repository, make changes, and submit a pull request. Any contributions, such as adding more software options or improving the script, are welcome!

License
This project is licensed under the MIT License - see the LICENSE file for details.