#!/bin/bash

# Note: This script is designed for Ubuntu 22.04 Server.
# The Lambda Stack (for CUDA and NVIDIA drivers) is only compatible with Ubuntu 22.04 Server.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages
install_packages() {
    echo "Installing required packages..."
    if command_exists apt-get; then
        if command_exists sudo; then
            sudo apt-get update && sudo apt-get install -y git tmux
        else
            apt-get update && apt-get install -y git tmux
        fi
    elif command_exists yum; then
        if command_exists sudo; then
            sudo yum update -y && sudo yum install -y git tmux
        else
            yum update -y && yum install -y git tmux
        fi
    else
        echo "Unable to install packages. Please install git and tmux manually."
        exit 1
    fi
}

# Function to install uv
install_uv() {
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
}

# Function to install CUDA and NVIDIA drivers
install_cuda_and_drivers() {
    echo
    echo "======================================================"
    echo "  IMPORTANT: CUDA and NVIDIA Drivers Installation"
    echo "======================================================"
    echo "Do you want to install CUDA and NVIDIA drivers using Lambda Stack?"
    echo "Note: Lambda Stack is ONLY compatible with Ubuntu 22.04 Server."
    echo
    echo "Enter 'yes' to install or 'no' to skip:"
    read -r response
    echo "======================================================"
    echo

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Installing CUDA and NVIDIA drivers..."
        wget -nv -O- https://lambdalabs.com/install-lambda-stack.sh | I_AGREE_TO_THE_CUDNN_LICENSE=1 sh -
    else
        echo "Skipping CUDA and NVIDIA drivers installation."
    fi
}

# Function to setup a project
setup_project() {
    local project_name=$1
    local repo_url=$2
    local extra_packages=$3

    echo "Setting up $project_name..."
    git clone "$repo_url"
    cd "$project_name"
    uv venv --python 3.12
    source .venv/bin/activate
    
    # Install basic build tools and torch
    uv pip install setuptools wheel
    uv pip install torch --no-build-isolation

    # Now install the rest of the packages
    uv pip install $extra_packages
    uv pip install -e '.[all]'
    deactivate
    cd ..
}

# Main script
main() {
    echo "This script is designed for Ubuntu 22.04 Server."
    echo "Some components (like Lambda Stack) may not work on other versions or distributions."
    echo

    # Check and install required packages
    if ! command_exists git || ! command_exists tmux; then
        install_packages
    fi

    # Verify tmux installation
    if ! command_exists tmux; then
        echo "tmux installation failed. Please install it manually and rerun the script."
        exit 1
    fi

    # Install uv
    if ! command_exists uv; then
        install_uv
    fi

    # Ask user if they want to install CUDA and NVIDIA drivers
    install_cuda_and_drivers

    # Setup Swift
    setup_project "swift" "https://github.com/modelscope/swift.git" "einops timm huggingface_hub[cli] hf_transfer flash-attn --no-build-isolation"

    # Setup Axolotl
    setup_project "axolotl" "https://github.com/axolotl-ai-cloud/axolotl" "packaging ninja flash-attn --no-build-isolation"
    
    echo "Installation complete!"
}

main
