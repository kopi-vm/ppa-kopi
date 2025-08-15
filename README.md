# ppa-kopi

Personal Package Archive (PPA) for [kopi](https://github.com/kopi-vm/kopi) - Java version management tool.

This repository hosts debian packages for kopi via GitHub Pages, providing an easy installation method for supported Linux distributions.

## Supported Platforms

### Linux Distributions
- Debian 11 (Bullseye)
- Debian 12 (Bookworm)
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Ubuntu 24.04 LTS (Noble Numbat)

### Architectures
- amd64 (x86_64)
- arm64 (aarch64)

> **Note**: The installer automatically detects and installs the appropriate binary for your system architecture.

## Installation

### Step 1: Import GPG Public Key
```bash
# Import the GPG key from Ubuntu keyserver
curl -fsSL https://keyserver.ubuntu.com/pks/lookup?op=get\&search=0xD2AC04A5A34E9BE3A8B32784F507C6D3DB058848 | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/kopi-archive-keyring.gpg > /dev/null
```

### Step 2: Add Repository
```bash
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/kopi-archive-keyring.gpg] \
  https://kopi-vm.github.io/ppa-kopi $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/kopi.list > /dev/null
```

### Step 3: Install kopi
```bash
sudo apt update
sudo apt install kopi
```

## Quick Installation (One-liner)

For a quick installation, you can use this one-liner script:

```bash
curl -fsSL https://kopi-vm.github.io/ppa-kopi/install.sh | bash
```

> **Note**: Always review scripts before running them with elevated privileges.

## Post-Installation

After installation, set up kopi with:

```bash
# Initialize kopi
kopi setup

# Add kopi shims to your PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.kopi/shims:$PATH"

# Install a Java version (e.g., Java 21)
kopi install 21

# Set as global default
kopi global 21

# Verify installation
java --version
```

## Uninstallation

To remove kopi from your system:

```bash
sudo apt-get remove --purge kopi
sudo rm /etc/apt/sources.list.d/kopi.list
sudo apt-get update
```

## License

This PPA repository follows the same license as the main [kopi project](https://github.com/kopi-vm/kopi).

