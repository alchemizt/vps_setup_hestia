#!/bin/bash
set -e

# Function to detect if Zsh is installed
is_zsh_installed() {
    if command -v zsh > /dev/null; then
        return 0  # Zsh is installed
    else
        return 1  # Zsh is not installed
    fi
}

# Function to add content to both .bashrc and .zshrc
add_to_shell_config() {
    local content="$1"
    local bashrc_file="$HOME/.bashrc"
    local zshrc_file="$HOME/.zshrc"

    # Append to .bashrc
    echo "$content" >> "$bashrc_file"
    echo "Added to $bashrc_file"

    # If Zsh is installed, append to .zshrc as well
    if is_zsh_installed; then
        echo "$content" >> "$zshrc_file"
        echo "Added to $zshrc_file"
    fi
}

# Function to add aliases
add_aliases() {
    echo "Adding aliases..."

    # Define the aliases
    declare -a aliases=(
        "alias ll='ls -la'"
        "alias gs='git status'"
        "alias ga='git add .'"
        "alias gp='git push'"
        "alias gc='git commit -m'"
        "alias ..='cd ..'"
        "alias ...='cd ../..'"
    )

    # Combine aliases into a single string
    local alias_string=""
    for alias in "${aliases[@]}"; do
        alias_string+="$alias"$'\n'
    done

    # Add aliases to shell configuration files
    add_to_shell_config "$alias_string"
}

# Function to add environment variables
add_environment_variables() {
    echo "Adding environment variables..."

    # Define the environment variables
    declare -a env_vars=(
        "export HCP_BIN=/usr/local/hestia/bin/"
        "export EDITOR=nano"
        "export PATH=\$PATH:/home/$USER/scripts"
    )

    # Combine environment variables into a single string
    local env_var_string=""
    for var in "${env_vars[@]}"; do
        env_var_string+="$var"$'\n'
    done

    # Add environment variables to shell configuration files
    add_to_shell_config "$env_var_string"
}

# Function to add custom functions
add_custom_functions() {
    echo "Adding custom functions..."

    # Define the custom functions
    declare -a custom_functions=(
        "function mkcd() { mkdir -p \"\$1\" && cd \"\$1\"; }"
        "function extract() { tar -xvf \"\$1\"; }"
        "function update_system() { sudo apt update && sudo apt upgrade -y; }"
    )

    # Combine custom functions into a single string
    local func_string=""
    for func in "${custom_functions[@]}"; do
        func_string+="$func"$'\n'
    done

    # Add custom functions to shell configuration files
    add_to_shell_config "$func_string"
}


install_doctl() {
  cd ~
  wget https://github.com/digitalocean/doctl/releases/download/v1.110.0/doctl-1.110.0-linux-amd64.tar.gz
  tar xf ~/doctl-1.110.0-linux-amd64.tar.gz
  sudo mv ~/doctl /usr/local/bin
}

install_direnv() {

  sudo apt-get install direnv 
  echo export ENVTEST="Environment variables working" > .envrc
  direnv allow .
  direnv hook bash >> ~/.bashrc

}

install_cloudflared() {
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloudflare-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg] https://pkg.cloudflare.com/ cloudflare main" | sudo tee /etc/apt/sources.list.d/cloudflare.list
    apt update
    sudo apt install cloudflared
}




install_optional_software() {
    echo "Optional software installation menu:"
    options=("Install Docker" "Install Node.js" "Install Python 3.10" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
            "Install Docker")
                echo "Installing Docker..."
                sudo apt-get install -y docker.io
                sudo systemctl enable --now docker
                echo "Docker installed!"
                ;;
            "Install Node.js")
                echo "Installing Node.js..."
                sudo apt-get install -y nodejs npm
                echo "Node.js installed!"
                ;;
            "Install Python 3.10")
                echo "Installing Python 3.10..."
                sudo apt-get install -y python3.10 python3.10-venv python3.10-dev
                echo "Python 3.10 installed!"
                ;;
            "Quit")
                break
                ;;
            *)
                echo "Invalid option $REPLY"
                ;;
        esac
    done
}

install_zsh() {
    echo "Installing ZSH..."
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "ZSH installed!"
}

# Script execution
add_aliases
add_environment_variables
add_custom_functions
install_cloudflared