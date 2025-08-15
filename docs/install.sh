#!/bin/bash
set -e

# kopi PPA installer script
# This script adds the kopi PPA repository and installs kopi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Check if running on supported distribution
check_distribution() {
    if ! command -v lsb_release &> /dev/null; then
        print_error "lsb_release not found. Please install lsb-release package."
        exit 1
    fi

    DISTRO=$(lsb_release -cs)
    case "$DISTRO" in
        bullseye|bookworm|jammy|noble)
            print_success "Detected supported distribution: $DISTRO"
            ;;
        *)
            print_error "Unsupported distribution: $DISTRO"
            print_info "Supported distributions: bullseye, bookworm, jammy, noble"
            exit 1
            ;;
    esac
}

# Check for required commands
check_requirements() {
    local missing_deps=()
    
    for cmd in curl gpg sudo; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=($cmd)
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required commands: ${missing_deps[*]}"
        print_info "Please install them first with: sudo apt update && sudo apt install ${missing_deps[*]}"
        exit 1
    fi
}

# Main installation
main() {
    echo "======================================"
    echo "     kopi PPA Repository Installer    "
    echo "======================================"
    echo

    # Check requirements
    print_info "Checking system requirements..."
    check_requirements
    check_distribution
    echo

    # GPG key fingerprint
    GPG_FINGERPRINT="D2AC04A5A34E9BE3A8B32784F507C6D3DB058848"
    KEYRING_PATH="/usr/share/keyrings/kopi-archive-keyring.gpg"
    
    # Import GPG key
    print_info "Importing GPG public key..."
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${GPG_FINGERPRINT}" | \
        gpg --dearmor | \
        sudo tee "$KEYRING_PATH" > /dev/null
    
    if [ $? -eq 0 ]; then
        print_success "GPG key imported successfully"
    else
        print_error "Failed to import GPG key"
        exit 1
    fi
    echo

    # Add repository
    print_info "Adding kopi repository..."
    echo "deb [arch=amd64,arm64 signed-by=${KEYRING_PATH}] https://kopi-vm.github.io/ppa-kopi $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/kopi.list > /dev/null
    
    if [ $? -eq 0 ]; then
        print_success "Repository added successfully"
    else
        print_error "Failed to add repository"
        exit 1
    fi
    echo

    # Update package list
    print_info "Updating package list..."
    sudo apt update
    
    if [ $? -eq 0 ]; then
        print_success "Package list updated"
    else
        print_error "Failed to update package list"
        exit 1
    fi
    echo

    # Install kopi
    print_info "Installing kopi..."
    sudo apt install -y kopi
    
    if [ $? -eq 0 ]; then
        print_success "kopi installed successfully!"
    else
        print_error "Failed to install kopi"
        exit 1
    fi
    echo

    # Post-installation instructions
    echo "======================================"
    echo "       Installation Complete!         "
    echo "======================================"
    echo
    echo "Next steps:"
    echo "1. Initialize kopi: kopi setup"
    echo "2. Add to PATH: export PATH=\"\$HOME/.kopi/shims:\$PATH\""
    echo "3. Install Java: kopi install 21"
    echo "4. Set global version: kopi global 21"
    echo
    echo "For more information, visit: https://github.com/kopi-vm/kopi"
}

# Run main function
main "$@"