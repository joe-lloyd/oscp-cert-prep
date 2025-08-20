#!/bin/bash
# Text Processing Practice Script for OSCP
# This script provides interactive practice for text processing commands

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

# Function to create sample data
create_sample_data() {
    print_color "$YELLOW" "Creating sample data files..."
    
    # Create a directory for sample data
    mkdir -p ~/text_processing_practice
    cd ~/text_processing_practice
    
    # Create a sample log file
    cat > sample_access.log << 'EOF'
192.168.1.10 - - [15/Aug/2023:10:24:32 +0000] "GET /index.html HTTP/1.1" 200 2571
192.168.1.15 - - [15/Aug/2023:10:25:43 +0000] "GET /images/logo.png HTTP/1.1" 200 4523
192.168.1.22 - - [15/Aug/2023:10:26:12 +0000] "GET /admin HTTP/1.1" 301 521
192.168.1.22 - - [15/Aug/2023:10:26:15 +0000] "GET /admin/ HTTP/1.1" 403 1234
192.168.1.10 - - [15/Aug/2023:10:27:51 +0000] "GET /about.html HTTP/1.1" 200 1822
192.168.1.45 - - [15/Aug/2023:10:28:32 +0000] "GET /login.php HTTP/1.1" 200 1234
192.168.1.45 - - [15/Aug/2023:10:28:45 +0000] "POST /login.php HTTP/1.1" 302 0
192.168.1.45 - - [15/Aug/2023:10:28:47 +0000] "GET /dashboard.php HTTP/1.1" 200 5432
192.168.1.60 - - [15/Aug/2023:10:29:02 +0000] "GET /nonexistent.html HTTP/1.1" 404 1122
192.168.1.22 - - [15/Aug/2023:10:30:12 +0000] "GET /admin/config HTTP/1.1" 404 1122
192.168.1.22 - - [15/Aug/2023:10:30:45 +0000] "GET /admin/console HTTP/1.1" 404 1122
192.168.1.22 - - [15/Aug/2023:10:31:15 +0000] "GET /admin/login HTTP/1.1" 200 1543
192.168.1.22 - - [15/Aug/2023:10:31:32 +0000] "POST /admin/login HTTP/1.1" 401 1122
192.168.1.22 - - [15/Aug/2023:10:31:45 +0000] "POST /admin/login HTTP/1.1" 401 1122
192.168.1.22 - - [15/Aug/2023:10:32:01 +0000] "POST /admin/login HTTP/1.1" 401 1122
192.168.1.10 - - [15/Aug/2023:10:35:22 +0000] "GET /contact.html HTTP/1.1" 200 1655
192.168.1.75 - - [15/Aug/2023:10:36:12 +0000] "GET /api/users HTTP/1.1" 200 2344
192.168.1.75 - - [15/Aug/2023:10:36:45 +0000] "GET /api/products HTTP/1.1" 200 5432
192.168.1.90 - - [15/Aug/2023:10:37:32 +0000] "GET /wp-login.php HTTP/1.1" 404 1122
192.168.1.90 - - [15/Aug/2023:10:37:45 +0000] "GET /administrator HTTP/1.1" 404 1122
192.168.1.90 - - [15/Aug/2023:10:38:01 +0000] "GET /phpmyadmin HTTP/1.1" 404 1122
192.168.1.100 - - [15/Aug/2023:10:40:12 +0000] "GET / HTTP/1.1" 200 2571
192.168.1.100 - - [15/Aug/2023:10:40:34 +0000] "GET /robots.txt HTTP/1.1" 200 245
192.168.1.100 - - [15/Aug/2023:10:40:55 +0000] "GET /sitemap.xml HTTP/1.1" 200 4321
EOF

    # Create a sample passwd file
    cat > sample_passwd.txt << 'EOF'
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

    # Create a sample config file
    cat > sample_config.conf << 'EOF'
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

    # Create a file with mixed data for regex practice
    cat > sample_mixed_data.txt << 'EOF'
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

    print_color "$GREEN" "Sample data created in ~/text_processing_practice"
    print_color "$GREEN" "Files created: sample_access.log, sample_passwd.txt, sample_config.conf, sample_mixed_data.txt"
}

# Function to run grep exercises
grep_exercises() {
    clear
    print_color "$BLUE" "===== GREP EXERCISES ====="
    print_color "$YELLOW" "Working with sample_access.log"
    
    echo
    print_color "$GREEN" "Exercise 1: Find all 404 errors"
    echo "Command: grep \"404\" sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "404" sample_access.log
    
    echo
    print_color "$GREEN" "Exercise 2: Count the number of 404 errors"
    echo "Command: grep -c \"404\" sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -c "404" sample_access.log
    
    echo
    print_color "$GREEN" "Exercise 3: Find all requests from IP 192.168.1.22"
    echo "Command: grep \"192.168.1.22\" sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "192.168.1.22" sample_access.log
    
    echo
    print_color "$GREEN" "Exercise 4: Extract all IP addresses using regex"
    echo "Command: grep -oE \"[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\" sample_access.log | sort | uniq"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" sample_access.log | sort | uniq
    
    echo
    print_color "$GREEN" "Exercise 5: Find all POST requests"
    echo "Command: grep \"POST\" sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "POST" sample_access.log
    
    echo
    print_color "$YELLOW" "Working with sample_config.conf"
    
    echo
    print_color "$GREEN" "Exercise 6: Find all password entries in the config file"
    echo "Command: grep \"password\" sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "password" sample_config.conf
    
    echo
    print_color "$GREEN" "Exercise 7: Find all lines that are not comments in the config file"
    echo "Command: grep -v \"^#\" sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -v "^#" sample_config.conf
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run sed exercises
sed_exercises() {
    clear
    print_color "$BLUE" "===== SED EXERCISES ====="
    print_color "$YELLOW" "Working with sample_config.conf"
    
    echo
    print_color "$GREEN" "Exercise 1: Replace 'localhost' with '127.0.0.1'"
    echo "Command: sed 's/localhost/127.0.0.1/g' sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    sed 's/localhost/127.0.0.1/g' sample_config.conf
    
    echo
    print_color "$GREEN" "Exercise 2: Replace all passwords with '[REDACTED]'"
    echo "Command: sed -E 's/(password = ).*/\\1[REDACTED]/g' sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    sed -E 's/(password = ).*/\1[REDACTED]/g' sample_config.conf
    
    echo
    print_color "$GREEN" "Exercise 3: Delete all comment lines"
    echo "Command: sed '/^#/d' sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    sed '/^#/d' sample_config.conf
    
    echo
    print_color "$GREEN" "Exercise 4: Print only the Database Configuration section"
    echo "Command: sed -n '/# Database Configuration/,/# Security Settings/p' sample_config.conf | sed '\$d'"
    echo "Try it yourself, then press Enter to see the answer"
    read
    sed -n '/# Database Configuration/,/# Security Settings/p' sample_config.conf | sed '$d'
    
    echo
    print_color "$GREEN" "Exercise 5: Add a new line at the end of the file"
    echo "Command: sed '\$a\\# End of configuration file' sample_config.conf"
    echo "Try it yourself, then press Enter to see the answer"
    read
    sed '$a\# End of configuration file' sample_config.conf
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run awk exercises
awk_exercises() {
    clear
    print_color "$BLUE" "===== AWK EXERCISES ====="
    print_color "$YELLOW" "Working with sample_passwd.txt"
    
    echo
    print_color "$GREEN" "Exercise 1: Print all usernames"
    echo "Command: awk -F: '{print \$1}' sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk -F: '{print $1}' sample_passwd.txt
    
    echo
    print_color "$GREEN" "Exercise 2: Print username and shell"
    echo "Command: awk -F: '{print \$1, \$7}' sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk -F: '{print $1, $7}' sample_passwd.txt
    
    echo
    print_color "$GREEN" "Exercise 3: Print only users with /bin/bash shell"
    echo "Command: awk -F: '\$7 == \"/bin/bash\" {print \$1}' sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk -F: '$7 == "/bin/bash" {print $1}' sample_passwd.txt
    
    echo
    print_color "$GREEN" "Exercise 4: Count users by shell type"
    echo "Command: awk -F: '{shells[\$7]++} END {for (s in shells) print s, shells[s]}' sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk -F: '{shells[$7]++} END {for (s in shells) print s, shells[s]}' sample_passwd.txt
    
    echo
    print_color "$YELLOW" "Working with sample_access.log"
    
    echo
    print_color "$GREEN" "Exercise 5: Print IP address and requested URL"
    echo "Command: awk '{print \$1, \$7}' sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $1, $7}' sample_access.log
    
    echo
    print_color "$GREEN" "Exercise 6: Count requests by status code"
    echo "Command: awk '{codes[\$9]++} END {for (c in codes) print c, codes[c]}' sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{codes[$9]++} END {for (c in codes) print c, codes[c]}' sample_access.log
    
    echo
    print_color "$GREEN" "Exercise 7: Calculate total bytes transferred"
    echo "Command: awk '{sum += \$10} END {print \"Total bytes: \" sum}' sample_access.log"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{sum += $10} END {print "Total bytes: " sum}' sample_access.log
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run cut exercises
cut_exercises() {
    clear
    print_color "$BLUE" "===== CUT EXERCISES ====="
    print_color "$YELLOW" "Working with sample_passwd.txt"
    
    echo
    print_color "$GREEN" "Exercise 1: Extract usernames"
    echo "Command: cut -d: -f1 sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    cut -d: -f1 sample_passwd.txt
    
    echo
    print_color "$GREEN" "Exercise 2: Extract username and home directory"
    echo "Command: cut -d: -f1,6 sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    cut -d: -f1,6 sample_passwd.txt
    
    echo
    print_color "$GREEN" "Exercise 3: Extract username and shell with custom delimiter"
    echo "Command: cut -d: -f1,7 --output-delimiter=' -> ' sample_passwd.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    cut -d: -f1,7 --output-delimiter=' -> ' sample_passwd.txt
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run sort and uniq exercises
sort_uniq_exercises() {
    clear
    print_color "$BLUE" "===== SORT AND UNIQ EXERCISES ====="
    print_color "$YELLOW" "Working with sample_access.log"
    
    echo
    print_color "$GREEN" "Exercise 1: Extract and sort IP addresses"
    echo "Command: awk '{print \$1}' sample_access.log | sort"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $1}' sample_access.log | sort
    
    echo
    print_color "$GREEN" "Exercise 2: Extract unique IP addresses"
    echo "Command: awk '{print \$1}' sample_access.log | sort | uniq"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $1}' sample_access.log | sort | uniq
    
    echo
    print_color "$GREEN" "Exercise 3: Count occurrences of each IP address"
    echo "Command: awk '{print \$1}' sample_access.log | sort | uniq -c | sort -nr"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $1}' sample_access.log | sort | uniq -c | sort -nr
    
    echo
    print_color "$GREEN" "Exercise 4: Extract and sort status codes"
    echo "Command: awk '{print \$9}' sample_access.log | sort | uniq -c | sort -nr"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $9}' sample_access.log | sort | uniq -c | sort -nr
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run regex exercises
regex_exercises() {
    clear
    print_color "$BLUE" "===== REGEX EXERCISES ====="
    print_color "$YELLOW" "Working with sample_mixed_data.txt"
    
    echo
    print_color "$GREEN" "Exercise 1: Extract all email addresses"
    echo "Command: grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}' sample_mixed_data.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' sample_mixed_data.txt
    
    echo
    print_color "$GREEN" "Exercise 2: Extract all IP addresses"
    echo "Command: grep -oE '([0-9]{1,3}\\.){3}[0-9]{1,3}' sample_mixed_data.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' sample_mixed_data.txt
    
    echo
    print_color "$GREEN" "Exercise 3: Extract all phone numbers"
    echo "Command: grep -oE '\\(?\d{3}\\)?[-. ]?\\d{3}[-. ]?\\d{4}' sample_mixed_data.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE '\(?\d{3}\)?[-. ]?\d{3}[-. ]?\d{4}' sample_mixed_data.txt
    
    echo
    print_color "$GREEN" "Exercise 4: Extract all URLs"
    echo "Command: grep -oE 'https?://[A-Za-z0-9.-]+\\.[A-Za-z]{2,}(/[A-Za-z0-9./_-]*)?\\??([A-Za-z0-9=&_-]*)?#?([A-Za-z0-9_-]*)?' sample_mixed_data.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE 'https?://[A-Za-z0-9.-]+\.[A-Za-z]{2,}(/[A-Za-z0-9./_-]*)?(\?([A-Za-z0-9=&_-]*))?(#([A-Za-z0-9_-]*))?' sample_mixed_data.txt
    
    echo
    print_color "$GREEN" "Exercise 5: Extract all credit card numbers"
    echo "Command: grep -oE '[0-9]{4}[-. ]?[0-9]{4}[-. ]?[0-9]{4}[-. ]?[0-9]{4}|[0-9]{15,16}' sample_mixed_data.txt"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep -oE '[0-9]{4}[-. ]?[0-9]{4}[-. ]?[0-9]{4}[-. ]?[0-9]{4}|[0-9]{15,16}' sample_mixed_data.txt
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Function to run command chaining exercises
command_chaining_exercises() {
    clear
    print_color "$BLUE" "===== COMMAND CHAINING EXERCISES ====="
    print_color "$YELLOW" "Working with all sample files"
    
    echo
    print_color "$GREEN" "Exercise 1: Find all bash users and their home directories"
    echo "Command: grep \"/bin/bash\" sample_passwd.txt | cut -d: -f1,6"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "/bin/bash" sample_passwd.txt | cut -d: -f1,6
    
    echo
    print_color "$GREEN" "Exercise 2: Count requests by IP and show top 3"
    echo "Command: awk '{print \$1}' sample_access.log | sort | uniq -c | sort -nr | head -3"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk '{print $1}' sample_access.log | sort | uniq -c | sort -nr | head -3
    
    echo
    print_color "$GREEN" "Exercise 3: Extract all passwords from config and replace with [REDACTED]"
    echo "Command: grep \"password\" sample_config.conf | sed -E 's/(password = ).*/\\1[REDACTED]/g'"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "password" sample_config.conf | sed -E 's/(password = ).*/\1[REDACTED]/g'
    
    echo
    print_color "$GREEN" "Exercise 4: Find all 404 errors and extract the requested URLs"
    echo "Command: grep \"404\" sample_access.log | awk '{print \$7}'"
    echo "Try it yourself, then press Enter to see the answer"
    read
    grep "404" sample_access.log | awk '{print $7}'
    
    echo
    print_color "$GREEN" "Exercise 5: Extract all unique shells and count users for each"
    echo "Command: awk -F: '{print \$7}' sample_passwd.txt | sort | uniq -c | sort -nr"
    echo "Try it yourself, then press Enter to see the answer"
    read
    awk -F: '{print $7}' sample_passwd.txt | sort | uniq -c | sort -nr
    
    echo
    print_color "$BLUE" "Press Enter to return to the main menu"
    read
}

# Main menu
main_menu() {
    while true; do
        clear
        print_color "$BLUE" "===== TEXT PROCESSING PRACTICE TOOL ====="
        print_color "$YELLOW" "Select an option:"
        echo "1. Create sample data"
        echo "2. Grep exercises"
        echo "3. Sed exercises"
        echo "4. Awk exercises"
        echo "5. Cut exercises"
        echo "6. Sort and Uniq exercises"
        echo "7. Regex exercises"
        echo "8. Command chaining exercises"
        echo "9. Exit"
        
        read -p "Enter your choice (1-9): " choice
        
        case $choice in
            1) create_sample_data ;;
            2) grep_exercises ;;
            3) sed_exercises ;;
            4) awk_exercises ;;
            5) cut_exercises ;;
            6) sort_uniq_exercises ;;
            7) regex_exercises ;;
            8) command_chaining_exercises ;;
            9) 
                print_color "$GREEN" "Thank you for practicing text processing commands!"
                exit 0
                ;;
            *)
                print_color "$RED" "Invalid option. Press Enter to continue."
                read
                ;;
        esac
    done
}

# Start the script
print_color "$GREEN" "Welcome to the Text Processing Practice Tool!"
print_color "$YELLOW" "This tool will help you practice text processing commands for OSCP."
echo
print_color "$YELLOW" "Press Enter to continue..."
read
main_menu
