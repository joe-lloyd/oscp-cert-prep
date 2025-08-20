#!/bin/bash
# Setup script for Command Line Fun practice environment
# This script sets up the necessary files and directories for command line practice

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${NC}"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_color "$RED" "Docker is not installed. Please install Docker first."
        print_color "$YELLOW" "Visit https://docs.docker.com/get-docker/ for installation instructions."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        print_color "$RED" "Docker Compose is not installed. Please install Docker Compose first."
        print_color "$YELLOW" "Visit https://docs.docker.com/compose/install/ for installation instructions."
        exit 1
    fi
}

# Create necessary directories
create_directories() {
    print_color "$BLUE" "Creating necessary directories..."
    
    # Create data directory if it doesn't exist
    if [ ! -d "data" ]; then
        mkdir -p data
        print_color "$GREEN" "Created data directory."
    fi
    
    # Create scripts directory if it doesn't exist
    if [ ! -d "scripts" ]; then
        mkdir -p scripts
        print_color "$GREEN" "Created scripts directory."
    fi
}

# Copy practice scripts to scripts directory
copy_scripts() {
    print_color "$BLUE" "Copying practice scripts..."
    
    # Check if scripts directory exists in parent directory
    if [ -d "../scripts" ]; then
        cp -r ../scripts/* scripts/
        print_color "$GREEN" "Copied scripts from ../scripts/ to scripts/."
    else
        # Copy scripts from current directory
        cp -f *.sh scripts/ 2>/dev/null
        print_color "$GREEN" "Copied scripts to scripts/ directory."
    fi
    
    # Make scripts executable
    chmod +x scripts/*.sh 2>/dev/null
    print_color "$GREEN" "Made scripts executable."
}

# Create sample data files
create_sample_data() {
    print_color "$BLUE" "Creating sample data files..."
    
    # Create sample passwd file
    cat > data/passwd.txt << 'EOF'
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin
sshd:x:104:65534::/run/sshd:/usr/sbin/nologin
mysql:x:105:113:MySQL Server,,,:/nonexistent:/bin/false
postfix:x:106:115::/var/spool/postfix:/usr/sbin/nologin
ftp:x:107:65534::/srv/ftp:/usr/sbin/nologin
john:x:1000:1000:John Smith,,,:/home/john:/bin/bash
jane:x:1001:1001:Jane Doe,,,:/home/jane:/bin/bash
bob:x:1002:1002:Bob Johnson,,,:/home/bob:/bin/zsh
alice:x:1003:1003:Alice Williams,,,:/home/alice:/bin/bash
dave:x:1004:1004:Dave Brown,,,:/home/dave:/bin/sh
EOF
    print_color "$GREEN" "Created sample passwd file."
    
    # Create sample config file
    cat > data/config.conf << 'EOF'
# Server Configuration
server_name = example.com
port = 443
max_connections = 1000
timeout = 30

# Database Configuration
db_host = localhost
db_port = 3306
db_name = example_db
db_user = db_user
db_password = supersecretpassword123

# Security Settings
enable_ssl = true
ssl_cert = /etc/ssl/certs/example.crt
ssl_key = /etc/ssl/private/example.key
allow_remote_admin = false
admin_ips = 192.168.1.10, 192.168.1.11

# Logging Configuration
log_level = info
log_file = /var/log/example.log
max_log_size = 100M
log_rotate = true
log_rotate_count = 5

# Email Configuration
smtp_server = smtp.example.com
smtp_port = 587
smtp_user = notifications@example.com
smtp_password = emailpassword456
notification_email = admin@example.com
EOF
    print_color "$GREEN" "Created sample config file."
    
    # Create sample mixed data file
    cat > data/mixed_data.txt << 'EOF'
User Information:
Name: John Smith
Email: john.smith@example.com
Phone: (555) 123-4567
SSN: 123-45-6789
Credit Card: 4111-1111-1111-1111
IP Address: 192.168.1.100

Name: Jane Doe
Email: jane_doe123@company.co.uk
Phone: 555.987.6543
SSN: 987-65-4321
Credit Card: 5500 0000 0000 0004
IP Address: 10.0.0.25

Name: Bob Johnson
Email: bob+johnson@gmail.com
Phone: 555-555-5555
SSN: 111-22-3333
Credit Card: 340000000000009
IP Address: 172.16.254.1

URLs:
http://example.com
https://secure.example.org/login
ftp://files.example.net/public
https://sub.domain.co.uk/path/to/file.html?param=value#section

Server Logs:
[2023-08-15 10:24:32] [INFO] User john.smith logged in from 192.168.1.10
[2023-08-15 10:25:43] [ERROR] Database connection failed: Connection refused
[2023-08-15 10:26:12] [WARNING] High memory usage detected: 85%
[2023-08-15 10:27:51] [INFO] User jane_doe123 logged in from 192.168.1.15
[2023-08-15 10:28:32] [ERROR] File not found: /var/www/html/missing.php
EOF
    print_color "$GREEN" "Created sample mixed data file."
    
    # Create wordlist for practice
    mkdir -p data/wordlists
    cat > data/wordlists/common_passwords.txt << 'EOF'
password
123456
12345678
qwerty
abc123
monkey
1234567
letmein
trustno1
dragon
baseball
111111
iloveyou
master
sunshine
ashley
bailey
passw0rd
shadow
123123
654321
superman
qazwsx
michael
football
welcome
jesus
ninja
mustang
password1
123456789
adobe123
admin
1234567890
photoshop
1234
12345
princess
azerty
000000
access
696969
batman
1qaz2wsx
login
qwertyuiop
solo
starwars
flower
hottie
loveme
zaq1zaq1
hello
freedom
whatever
666666
!@#$%^&*
charlie
aa123456
donald
qwerty123
secret
abcd1234
EOF
    print_color "$GREEN" "Created sample wordlist."
}

# Start Docker containers
start_containers() {
    print_color "$BLUE" "Starting Docker containers..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        print_color "$RED" "docker-compose.yml not found. Please make sure you're in the correct directory."
        exit 1
    fi
    
    # Start containers
    docker-compose up -d
    
    # Check if containers started successfully
    if [ $? -eq 0 ]; then
        print_color "$GREEN" "Docker containers started successfully."
    else
        print_color "$RED" "Failed to start Docker containers."
        exit 1
    fi
}

# Print usage instructions
print_instructions() {
    print_color "$BLUE" "===== COMMAND LINE PRACTICE ENVIRONMENT ====="
    print_color "$GREEN" "The practice environment has been set up successfully."
    echo
    print_color "$YELLOW" "To access the Kali Linux container:"
    echo "docker exec -it oscp-command-line-kali bash"
    echo
    print_color "$YELLOW" "To access the Ubuntu target container:"
    echo "docker exec -it oscp-command-line-target bash"
    echo
    print_color "$YELLOW" "To access the DVWA web application:"
    echo "http://localhost:8080"
    echo
    print_color "$YELLOW" "Network Information:"
    echo "Kali Linux: 172.20.0.2"
    echo "Ubuntu Target: 172.20.0.3"
    echo "DVWA: 172.20.0.4"
    echo
    print_color "$YELLOW" "To stop the environment:"
    echo "docker-compose down"
    echo
    print_color "$GREEN" "Happy hacking!"
}

# Main function
main() {
    print_color "$BLUE" "===== SETTING UP COMMAND LINE PRACTICE ENVIRONMENT ====="
    
    # Check if Docker is installed
    check_docker
    
    # Create necessary directories
    create_directories
    
    # Copy practice scripts
    copy_scripts
    
    # Create sample data files
    create_sample_data
    
    # Start Docker containers
    start_containers
    
    # Print usage instructions
    print_instructions
}

# Run main function
main
