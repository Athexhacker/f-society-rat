#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "  ______             _____  ____   _____ _____ ______ _________     __ "
echo " |  ____|           / ____|/ __ \ / ____|_   _|  ____|__   __\ \   / / "
echo " | |__     ______  | (___ | |  | | |      | | | |__     | |   \ \_/ /  "
echo " |  __|   |______|  \___ \| |  | | |      | | |  __|    | |    \   /   "
echo " | |                ____) | |__| | |____ _| |_| |____   | |     | |    "
echo " |_|               |_____/ \____/ \_____|_____|______|  |_|     |_|    "
echo -e "${NC}"
echo -e "${YELLOW}Metasploit Framework Installer for Termux${NC}"
echo -e "${BLUE}Created by: ATHEX BLACK H4T${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[-]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Internet connection (improved)
check_internet() {
    print_status "Checking Internet connection..."
    
    # Try multiple methods to check internet connectivity
    local methods=(
        "ping -c 1 -W 3 8.8.8.8"
        "ping -c 1 -W 3 google.com"
        "curl -s --connect-timeout 5 -I http://www.google.com"
        "wget -q --spider --timeout=5 http://www.github.com"
    )
    
    for method in "${methods[@]}"; do
        if eval "$method" >/dev/null 2>&1; then
            print_success "Internet connection is available"
            return 0
        fi
    done
    
    print_error "No Internet connection. Please check your connection and try again."
    print_warning "Make sure you have:"
    print_warning "1. Working internet connection"
    print_warning "2. No VPN blocking connectivity"
    print_warning "3. Proper DNS settings"
    
    # Ask user if they want to continue anyway
    echo -n "Do you want to continue without internet check? (y/N): "
    read -r continue_anyway
    if [[ $continue_anyway =~ ^[Yy]$ ]]; then
        print_warning "Continuing without internet verification..."
        return 0
    else
        exit 1
    fi
}

# Function to update and upgrade packages
update_packages() {
    print_status "Updating package lists..."
    if pkg update -y; then
        print_success "Package lists updated successfully"
    else
        print_error "Failed to update package lists"
        exit 1
    fi

    print_status "Upgrading packages..."
    if pkg upgrade -y; then
        print_success "Packages upgraded successfully"
    else
        print_warning "Package upgrade had some issues, but continuing..."
    fi
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing required dependencies..."
    
    local dependencies=(wget curl git ruby python python-pip ncurses-utils)
    
    for pkg in "${dependencies[@]}"; do
        if pkg list-installed | grep -q "$pkg"; then
            print_success "$pkg is already installed"
        else
            print_status "Installing $pkg..."
            if pkg install -y "$pkg"; then
                print_success "$pkg installed successfully"
            else
                print_error "Failed to install $pkg"
                exit 1
            fi
        fi
    done
}

# Function to install Metasploit
install_metasploit() {
    print_status "Starting Metasploit Framework installation..."
    
    # Check if Metasploit is already installed
    if command_exists msfconsole; then
        print_warning "Metasploit seems to be already installed."
        echo -n "Do you want to reinstall? (y/N): "
        read -r reinstall
        if [[ ! $reinstall =~ ^[Yy]$ ]]; then
            print_status "Skipping Metasploit installation."
            return 0
        fi
    fi
    
    # Download and install Metasploit
    print_status "Downloading Metasploit installer..."
    cd "$HOME" || exit 1
    
    # Try multiple sources for Metasploit installer
    local installer_sources=(
        "https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/metasploit.sh"
        "https://raw.githubusercontent.com/termux/metasploit_in_termux/master/metasploit.sh"
    )
    
    local download_success=false
    
    for source in "${installer_sources[@]}"; do
        print_status "Trying source: $source"
        if wget -O metasploit.sh "$source"; then
            download_success=true
            print_success "Metasploit installer downloaded successfully"
            break
        else
            print_warning "Failed to download from: $source"
        fi
    done
    
    if [ "$download_success" = false ]; then
        print_error "Failed to download Metasploit installer from all sources"
        exit 1
    fi
    
    # Make the installer executable
    chmod +x metasploit.sh
    
    print_status "Running Metasploit installer (This may take 10-15 minutes)..."
    print_warning "Do not interrupt the installation process!"
    echo -e "${YELLOW}The installation will take some time. Please be patient...${NC}"
    
    if ./metasploit.sh; then
        print_success "Metasploit Framework installed successfully"
    else
        print_error "Metasploit installation failed"
        exit 1
    fi
    
    # Clean up installer
    rm -f metasploit.sh
}

# Function to configure environment
configure_environment() {
    print_status "Configuring environment..."
    
    # Add Ruby gems to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/share/gem/ruby/3.0.0/bin:"* ]]; then
        echo 'export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"' >> "$HOME/.bashrc"
        print_success "Added Ruby gems to PATH"
    fi
    
    # Add local bin to PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
        print_success "Added local bin to PATH"
    fi
    
    # Source bashrc
    source "$HOME/.bashrc"
}

# Function to verify installation
verify_installation() {
    print_status "Verifying Metasploit installation..."
    
    # Check if msfconsole command works
    if command_exists msfconsole; then
        print_success "Metasploit is installed and accessible"
    else
        print_error "Metasploit installation verification failed"
        exit 1
    fi
    
    # Check msfvenom
    if command_exists msfvenom; then
        print_success "msfvenom is installed and accessible"
    else
        print_error "msfvenom not found"
        exit 1
    fi
    
    # Test basic functionality
    print_status "Testing Metasploit basic functionality..."
    if msfconsole --version >/dev/null 2>&1; then
        print_success "Metasploit basic functionality test passed"
    else
        print_warning "Metasploit version check failed, but installation seems complete"
    fi
}

# Function to install additional tools
install_additional_tools() {
    print_status "Installing additional useful tools..."
    
    local tools=(nmap hydra sqlmap)
    
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            print_status "Installing $tool..."
            if pkg install -y "$tool"; then
                print_success "$tool installed successfully"
            else
                print_warning "Failed to install $tool, but continuing..."
            fi
        else
            print_success "$tool is already installed"
        fi
    done
}

# Function to display usage information
show_usage() {
    echo -e "${CYAN}"
    cat << "EOF"
Usage: ./install_metasploit.sh [OPTIONS]

Options:
    -h, --help      Show this help message
    -y, --yes       Run without prompts (auto yes to all)
    -s, --silent    Run in silent mode (minimal output)
    --skip-update   Skip package update and upgrade
    --only-msf      Install only Metasploit, skip additional tools
    --auto-find     Auto find and run setup scripts in current directory

Examples:
    ./install_metasploit.sh           # Interactive installation
    ./install_metasploit.sh -y        # Auto yes to all prompts
    ./install_metasploit.sh --only-msf # Install only Metasploit
    ./install_metasploit.sh --auto-find # Auto find and run setup scripts
EOF
    echo -e "${NC}"
}

# Function to setup storage
setup_storage() {
    print_status "Setting up storage permissions..."
    if termux-setup-storage; then
        print_success "Storage setup completed"
    else
        print_warning "Storage setup may have issues, but continuing..."
    fi
}

# Function to auto-find and run setup scripts
auto_find_and_run_scripts() {
    print_status "Scanning for setup scripts in current directory..."
    
    local scripts_found=()
    local run_sh_found=false
    local auto_find_found=false
    
    # Look for common setup script patterns
    for script in *.sh; do
        if [[ -f "$script" && -x "$script" ]]; then
            case "$script" in
                "run.sh")
                    run_sh_found=true
                    scripts_found+=("$script")
                    ;;
                "setup.sh"|"install.sh"|"auto_find.sh"|"metasploit.sh")
                    scripts_found+=("$script")
                    ;;
            esac
        fi
    done
    
    # Also check for non-executable but relevant scripts
    for script in *.sh; do
        if [[ -f "$script" ]]; then
            case "$script" in
                "run.sh")
                    if [ "$run_sh_found" = false ]; then
                        scripts_found+=("$script")
                        run_sh_found=true
                    fi
                    ;;
                "setup.sh"|"install.sh"|"auto_find.sh"|"metasploit.sh")
                    if [[ ! " ${scripts_found[@]} " =~ " ${script} " ]]; then
                        scripts_found+=("$script")
                    fi
                    ;;
            esac
        fi
    done
    
    if [ ${#scripts_found[@]} -eq 0 ]; then
        print_warning "No setup scripts found in current directory"
        return 1
    fi
    
    print_success "Found ${#scripts_found[@]} script(s): ${scripts_found[*]}"
    
    # Prioritize run.sh
    if [ "$run_sh_found" = true ]; then
        print_status "Found run.sh - executing it first..."
        if [ -x "run.sh" ]; then
            ./run.sh
        else
            chmod +x run.sh && ./run.sh
        fi
        return $?
    fi
    
    # If no run.sh, ask user which script to run
    if [ ${#scripts_found[@]} -gt 1 ]; then
        echo ""
        echo "Multiple scripts found:"
        for i in "${!scripts_found[@]}"; do
            echo "  $((i+1)). ${scripts_found[$i]}"
        done
        echo -n "Select script to run (1-${#scripts_found[@]}): "
        read -r choice
        
        if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#scripts_found[@]} ]; then
            selected_script="${scripts_found[$((choice-1))]}"
            print_status "Executing $selected_script..."
            if [ -x "$selected_script" ]; then
                ./"$selected_script"
            else
                chmod +x "$selected_script" && ./"$selected_script"
            fi
            return $?
        else
            print_error "Invalid selection"
            return 1
        fi
    else
        # Only one script found
        print_status "Executing ${scripts_found[0]}..."
        if [ -x "${scripts_found[0]}" ]; then
            ./"${scripts_found[0]}"
        else
            chmod +x "${scripts_found[0]}" && ./"${scripts_found[0]}"
        fi
        return $?
    fi
}

# Function to run post-installation setup
run_post_install_setup() {
    print_status "Running post-installation setup..."
    
    # Check if we're in a directory with setup scripts
    if [ -f "run.sh" ] || [ -f "setup.sh" ] || [ -f "auto_find.sh" ]; then
        echo -n "Found setup scripts in current directory. Run them now? (Y/n): "
        read -r run_setup
        if [[ ! $run_setup =~ ^[Nn]$ ]]; then
            auto_find_and_run_scripts
        fi
    fi
    
    # Initialize Metasploit database
    print_status "Initializing Metasploit database..."
    if command_exists msfdb; then
        if msfdb init; then
            print_success "Metasploit database initialized"
        else
            print_warning "Metasploit database initialization failed or already exists"
        fi
    fi
}

# Main installation function
main() {
    local AUTO_YES=false
    local SILENT=false
    local SKIP_UPDATE=false
    local ONLY_MSF=false
    local AUTO_FIND=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -y|--yes)
                AUTO_YES=true
                shift
                ;;
            -s|--silent)
                SILENT=true
                shift
                ;;
            --skip-update)
                SKIP_UPDATE=true
                shift
                ;;
            --only-msf)
                ONLY_MSF=true
                shift
                ;;
            --auto-find)
                AUTO_FIND=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Handle auto-find mode
    if [ "$AUTO_FIND" = true ]; then
        auto_find_and_run_scripts
        exit $?
    fi
    
    # Welcome message
    if [ "$SILENT" = false ]; then
        echo -e "${CYAN}"
        echo "=========================================="
        echo "    Metasploit Framework Installer"
        echo "=========================================="
        echo -e "${NC}"
        echo "This script will:"
        echo "1. Check Internet connection"
        echo "2. Update and upgrade packages"
        echo "3. Install dependencies"
        echo "4. Install Metasploit Framework"
        echo "5. Configure environment"
        echo "6. Verify installation"
        echo "7. Install additional tools (optional)"
        echo "8. Run post-installation setup"
        echo ""
        
        if [ "$AUTO_YES" = false ]; then
            echo -n "Do you want to continue? (Y/n): "
            read -r continue
            if [[ $continue =~ ^[Nn]$ ]]; then
                print_status "Installation cancelled by user."
                exit 0
            fi
        fi
    fi
    
    # Start installation process
    check_internet
    
    if [ "$SKIP_UPDATE" = false ]; then
        update_packages
    else
        print_status "Skipping package update as requested"
    fi
    
    install_dependencies
    setup_storage
    install_metasploit
    configure_environment
    verify_installation
    
    if [ "$ONLY_MSF" = false ] && [ "$AUTO_YES" = true ]; then
        install_additional_tools
    elif [ "$ONLY_MSF" = false ] && [ "$AUTO_YES" = false ] && [ "$SILENT" = false ]; then
        echo ""
        echo -n "Do you want to install additional tools (nmap, hydra, sqlmap)? (Y/n): "
        read -r additional
        if [[ ! $additional =~ ^[Nn]$ ]]; then
            install_additional_tools
        fi
    fi
    
    # Run post-installation setup
    run_post_install_setup
    
    # Final message
    echo ""
    echo -e "${GREEN}"
    echo "=========================================="
    echo "    Installation Completed Successfully!"
    echo "=========================================="
    echo -e "${NC}"
    echo -e "${CYAN}Metasploit Framework is now installed and ready to use.${NC}"
    echo ""
    echo -e "${YELLOW}Available commands:${NC}"
    echo -e "  ${GREEN}msfconsole${NC}   - Start Metasploit Framework"
    echo -e "  ${GREEN}msfvenom${NC}     - Create payloads"
    echo -e "  ${GREEN}msfdb${NC}        - Database management"
    echo ""
    echo -e "${YELLOW}Quick start:${NC}"
    echo -e "  1. Run: ${CYAN}msfconsole${NC}"
    echo -e "  2. Type: ${CYAN}help${NC} to see available commands"
    echo ""
    echo -e "${BLUE}Note:${NC} First run may take some time to initialize the database."
    echo ""
    
    # Test command
    if [ "$SILENT" = false ]; then
        echo -n "Do you want to test Metasploit now? (y/N): "
        read -r test
        if [[ $test =~ ^[Yy]$ ]]; then
            print_status "Starting Metasploit test..."
            msfconsole --version
        fi
    fi
}

# Run main function with all arguments
main "$@"