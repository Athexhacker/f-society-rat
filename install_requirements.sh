#!/bin/bash
echo "Checking For Root User...."
sleep 1

# Function to install apktool for non-root users
install_non_root() {
    echo "Installing for non-root user: $USER"
    echo -e "\033[0;33m"
    echo "Executing apktool installer ..."
    
    # Create local bin directory if it doesn't exist
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/sbin
    
    # Copy files to user's local directories
    cp -r apktool ~/.local/bin/
    cp -r apktool.jar ~/.local/bin/
    cp -r apktool ~/.local/sbin/
    cp -r apktool.jar ~/.local/sbin/
    
    # Set permissions
    chmod +x ~/.local/bin/apktool
    chmod +x ~/.local/bin/apktool.jar
    chmod +x ~/.local/sbin/apktool
    chmod +x ~/.local/sbin/apktool.jar
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/sbin:$PATH"' >> ~/.bashrc
        echo "Added ~/.local/bin to PATH in ~/.bashrc"
        echo "Please run 'source ~/.bashrc' or restart your terminal"
    fi
    
    echo "Installation Complete ..."
    sleep 1
    echo -e "\033[0;33mNow you are able to\033[0;37m bind payloads\033[0;33m with any apk"
}

# Function to install apktool for root users
install_root() {
    echo -e "\033[0;33m"
    echo "Executing apktool installer ..."
    cp -r apktool /usr/local/bin
    cp -r apktool /usr/local/sbin
    cp -r apktool.jar /usr/local/bin
    cp -r apktool.jar /usr/local/sbin
    cp -r apktool /usr/sbin
    cp -r apktool.jar /usr/sbin
    chmod +x /usr/local/bin/apktool.jar
    chmod +x /usr/local/sbin/apktool.jar
    chmod +x /usr/local/bin/apktool
    chmod +x /usr/local/sbin/apktool
    chmod +x /usr/sbin/apktool
    chmod +x /usr/sbin/apktool.jar
    
    # Install apksigner if available
    if command -v apt &> /dev/null; then
        echo "Installing apksigner ..."
        apt install apksigner -y
    elif command -v pacman &> /dev/null; then
        echo "Installing apksigner ..."
        pacman -S apksigner --noconfirm
    elif command -v dnf &> /dev/null; then
        echo "Installing apksigner ..."
        dnf install apksigner -y
    else
        echo "Note: Package manager not detected. You may need to install apksigner manually."
    fi
    
    echo "Installation Complete ..."
    sleep 1
    echo -e "\033[0;33mNow you are able to\033[0;37m bind payloads\033[0;33m with any apk"
}

# Check if root
if [[ $(id -u) -ne 0 ]] ; then 
   echo "You are Not Root! Installing in user mode..."
   install_non_root
else
   echo "You are Root! Installing system-wide..."
   install_root
fi