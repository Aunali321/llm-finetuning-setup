# LLM Fine-tuning Environment Setup Script

This script automates the installation of libraries and packages required for LLM fine-tuning on Linux systems. It's designed for Ubuntu 22.04 Server, but can be adapted for other distributions.

## Features

* Installs essential tools like `git`, `tmux`, and `uv`.
* Sets up Python 3.12 virtual environments using `uv`.
* Installs Swift and Axolotl for fine-tuning LLMs.
* Optionally installs CUDA and NVIDIA drivers using Lambda Stack (Ubuntu 22.04 Server only).
* Handles systems with or without `sudo`.

## Prerequisites

* A Linux system (preferably Ubuntu 22.04 Server).
* Internet connection.

## Installation

1. Clone this repository:

```bash
git clone https://github.com/Aunali321/llm-finetuning-setup.git
```

2. Navigate to the cloned directory:

```bash
cd llm-finetuning-setup
```

3. Make the script executable:

```bash
chmod +x setup_llm_env.sh
```

4. Run the script:

```bash
./setup_llm_env.sh 
```

If you're on a system without `sudo`, you may need to run it with root privileges:

```bash
su -c ./setup_llm_env.sh
```

## Usage

The script will guide you through the installation process. It will ask for confirmation before installing CUDA and NVIDIA drivers (if desired).

## Compatibility notes
* This script is optimized for Ubuntu 22.04 Server. Some components, particularly the Lambda Stack for CUDA/NVIDIA driver installation, are designed specifically for this distribution.
* While the core functionality might work on other distributions, you may need to adapt the package installation commands accordingly.

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.
```
