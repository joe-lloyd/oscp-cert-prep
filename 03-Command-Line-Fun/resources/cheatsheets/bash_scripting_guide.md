# Bash Scripting Guide for OSCP

This guide provides essential bash scripting concepts and examples relevant to OSCP penetration testing tasks.

## Basic Script Structure

```bash
#!/bin/bash
# Script description
# Author: Your Name
# Date: YYYY-MM-DD

# Variables
NAME="John"
AGE=30

# Main code
echo "Hello, $NAME!"
echo "You are $AGE years old."

# Exit with success status
exit 0
```

## Variables and Data Types

### Variable Declaration
```bash
# No spaces around the equals sign
NAME="John Doe"
AGE=30
IS_ADMIN=true
```

### Variable Usage
```bash
echo "Name: $NAME"
echo "Age: ${AGE}"
echo "Admin: ${IS_ADMIN}"
```

### Command Substitution
```bash
CURRENT_DIR=$(pwd)
FILES=$(ls -la)
DATE=$(date +%Y-%m-%d)
```

### Environment Variables
```bash
echo "Home directory: $HOME"
echo "User: $USER"
echo "Path: $PATH"
echo "Shell: $SHELL"
```

## Input and Output

### User Input
```bash
echo "Enter your name:"
read NAME

echo "Enter your age:"
read AGE

# Read with prompt
read -p "Enter your username: " USERNAME

# Silent input (for passwords)
read -sp "Enter your password: " PASSWORD
echo # New line after password input
```

### Command Line Arguments
```bash
# $0 - Script name
# $1, $2, ... - Arguments
# $# - Number of arguments
# $@ - All arguments as separate strings
# $* - All arguments as a single string

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Number of arguments: $#"
echo "All arguments: $@"
```

### Output Redirection
```bash
# Redirect stdout to file
echo "Hello" > file.txt

# Append stdout to file
echo "World" >> file.txt

# Redirect stderr to file
command 2> errors.txt

# Redirect both stdout and stderr to file
command > output.txt 2>&1

# Discard output
command > /dev/null 2>&1
```

## Control Structures

### Conditionals

#### If-Else Statement
```bash
if [ "$AGE" -ge 18 ]; then
    echo "You are an adult."
elif [ "$AGE" -ge 13 ]; then
    echo "You are a teenager."
else
    echo "You are a child."
fi
```

#### Case Statement
```bash
case "$OPTION" in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
```

### Loops

#### For Loop
```bash
# Iterate over a list
for NAME in John Jane Bob Alice; do
    echo "Hello, $NAME!"
done

# Iterate over a range
for i in {1..5}; do
    echo "Number: $i"
done

# C-style for loop
for ((i=1; i<=5; i++)); do
    echo "Count: $i"
done

# Iterate over files
for FILE in *.txt; do
    echo "Processing $FILE"
done
```

#### While Loop
```bash
# Count from 1 to 5
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Read file line by line
while read LINE; do
    echo "Line: $LINE"
done < file.txt
```

#### Until Loop
```bash
# Count from 1 to 5
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

## Comparison Operators

### String Comparison
```bash
if [ "$STR1" = "$STR2" ]; then
    echo "Strings are equal"
fi

if [ "$STR1" != "$STR2" ]; then
    echo "Strings are not equal"
fi

if [ -z "$STR" ]; then
    echo "String is empty"
fi

if [ -n "$STR" ]; then
    echo "String is not empty"
fi
```

### Numeric Comparison
```bash
if [ "$NUM1" -eq "$NUM2" ]; then
    echo "Numbers are equal"
fi

if [ "$NUM1" -ne "$NUM2" ]; then
    echo "Numbers are not equal"
fi

if [ "$NUM1" -lt "$NUM2" ]; then
    echo "NUM1 is less than NUM2"
fi

if [ "$NUM1" -le "$NUM2" ]; then
    echo "NUM1 is less than or equal to NUM2"
fi

if [ "$NUM1" -gt "$NUM2" ]; then
    echo "NUM1 is greater than NUM2"
fi

if [ "$NUM1" -ge "$NUM2" ]; then
    echo "NUM1 is greater than or equal to NUM2"
fi
```

### File Tests
```bash
if [ -e "$FILE" ]; then
    echo "File exists"
fi

if [ -f "$FILE" ]; then
    echo "Regular file exists"
fi

if [ -d "$DIR" ]; then
    echo "Directory exists"
fi

if [ -r "$FILE" ]; then
    echo "File is readable"
fi

if [ -w "$FILE" ]; then
    echo "File is writable"
fi

if [ -x "$FILE" ]; then
    echo "File is executable"
fi

if [ -s "$FILE" ]; then
    echo "File is not empty"
fi
```

### Logical Operators
```bash
# AND
if [ "$AGE" -ge 18 ] && [ "$HAS_ID" = true ]; then
    echo "You can enter"
fi

# OR
if [ "$AGE" -ge 65 ] || [ "$IS_VETERAN" = true ]; then
    echo "You get a discount"
fi

# NOT
if [ ! -f "$FILE" ]; then
    echo "File does not exist"
fi
```

## Functions

### Function Definition and Usage
```bash
# Define function
greet() {
    local NAME="$1"
    echo "Hello, $NAME!"
}

# Call function
greet "John"

# Function with return value
is_even() {
    if [ $(($1 % 2)) -eq 0 ]; then
        return 0  # Success (true)
    else
        return 1  # Failure (false)
    fi
}

# Use function return value
if is_even 4; then
    echo "4 is even"
else
    echo "4 is odd"
fi
```

## Arrays

### Array Operations
```bash
# Define array
NAMES=("John" "Jane" "Bob" "Alice")

# Access element
echo "First name: ${NAMES[0]}"

# All elements
echo "All names: ${NAMES[@]}"

# Array length
echo "Number of names: ${#NAMES[@]}"

# Add element
NAMES+=("Dave")

# Iterate over array
for NAME in "${NAMES[@]}"; do
    echo "Hello, $NAME!"
done
```

## String Manipulation

### String Operations
```bash
STR="Hello, World!"

# String length
echo "Length: ${#STR}"

# Substring
echo "Substring: ${STR:7:5}"  # Starts at index 7, length 5

# Replace
echo "Replace: ${STR/World/OSCP}"  # Replace first occurrence
echo "Replace all: ${STR//o/O}"    # Replace all occurrences

# Case conversion
echo "Uppercase: ${STR^^}"
echo "Lowercase: ${STR,,}"
```

## Error Handling

### Basic Error Handling
```bash
# Exit on error
set -e

# Custom error function
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Usage
[ -f "$CONFIG_FILE" ] || error_exit "Config file not found"

# Trap for cleanup
trap 'echo "Script interrupted"; cleanup; exit 1' INT TERM

cleanup() {
    echo "Cleaning up temporary files..."
    rm -f /tmp/tempfile_$$
}
```

## OSCP-Relevant Script Examples

### Network Scanner
```bash
#!/bin/bash
# Simple network scanner

if [ $# -ne 1 ]; then
    echo "Usage: $0 <network>"
    echo "Example: $0 192.168.1"
    exit 1
fi

NETWORK="$1"

echo "Scanning network: $NETWORK.0/24"
echo "Live hosts:"

for i in {1..254}; do
    # Ping each host with timeout
    ping -c 1 -W 1 "$NETWORK.$i" &>/dev/null && echo "$NETWORK.$i is up"
done
```

### Port Scanner
```bash
#!/bin/bash
# Simple port scanner

if [ $# -ne 1 ]; then
    echo "Usage: $0 <target>"
    echo "Example: $0 192.168.1.1"
    exit 1
fi

TARGET="$1"
TIMEOUT=1

echo "Scanning common ports on $TARGET"
echo "Open ports:"

# Common ports to scan
PORTS=(21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1723 3306 3389 5900 8080)

for PORT in "${PORTS[@]}"; do
    (echo > /dev/tcp/$TARGET/$PORT) >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$PORT/tcp open"
    fi
done
```

### Banner Grabber
```bash
#!/bin/bash
# Simple banner grabber

if [ $# -ne 2 ]; then
    echo "Usage: $0 <target> <port>"
    echo "Example: $0 192.168.1.1 80"
    exit 1
fi

TARGET="$1"
PORT="$2"
TIMEOUT=5

echo "Grabbing banner from $TARGET:$PORT"

# Try HTTP banner
if [ "$PORT" -eq 80 ] || [ "$PORT" -eq 8080 ]; then
    echo -e "GET / HTTP/1.1\r\nHost: $TARGET\r\n\r\n" | nc -w $TIMEOUT $TARGET $PORT
else
    # Generic banner grab
    echo "" | nc -w $TIMEOUT $TARGET $PORT
fi
```

### File Permission Checker
```bash
#!/bin/bash
# Check for files with insecure permissions

echo "Checking for world-writable files in /etc:"
find /etc -type f -perm -o+w -exec ls -la {} \;

echo -e "\nChecking for SUID binaries:"
find / -perm -u=s -type f 2>/dev/null | sort
```

### Password Generator
```bash
#!/bin/bash
# Generate random passwords

LENGTH=${1:-12}  # Default length is 12

# Generate password with alphanumeric and special characters
PASS=$(tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c $LENGTH)
echo "Random password: $PASS"

# Generate password with only alphanumeric characters
ALPHANUM=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $LENGTH)
echo "Alphanumeric password: $ALPHANUM"
```

### Log Parser
```bash
#!/bin/bash
# Parse Apache access logs for potential attacks

LOG_FILE=${1:-/var/log/apache2/access.log}

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

echo "Analyzing log file: $LOG_FILE"

echo -e "\nPotential SQL injection attempts:"
grep -i "select\|union\|insert\|drop\|update\|delete\|where" "$LOG_FILE"

echo -e "\nPotential directory traversal attempts:"
grep -i "\.\./\|\.\.\\" "$LOG_FILE"

echo -e "\nPotential XSS attempts:"
grep -i "<script\|javascript:" "$LOG_FILE"

echo -e "\nPotential file inclusion attempts:"
grep -i "include\|require\|file=" "$LOG_FILE"

echo -e "\nTop 10 IP addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10

echo -e "\n404 errors:"
grep " 404 " "$LOG_FILE" | tail -10
```

### Automated Enumeration Script
```bash
#!/bin/bash
# Basic system enumeration for privilege escalation

echo "=== System Information ==="
hostname
uname -a
cat /etc/*-release 2>/dev/null

echo -e "\n=== Current User ==="
id
whoami
groups

echo -e "\n=== Sudo Access ==="
sudo -l 2>/dev/null

echo -e "\n=== Environment Variables ==="
env | grep -v "LS_COLORS"

echo -e "\n=== Running Processes ==="
ps aux | grep "^root"

echo -e "\n=== SUID Binaries ==="
find / -perm -u=s -type f 2>/dev/null | sort

echo -e "\n=== World-Writable Directories ==="
find / -writable -type d 2>/dev/null | sort

echo -e "\n=== Cron Jobs ==="
ls -la /etc/cron*
cat /etc/crontab 2>/dev/null

echo -e "\n=== Network Information ==="
ip a
netstat -tuln

echo -e "\n=== Installed Software ==="
which nmap aws nc ncat netcat wget curl ping gcc python python3 perl php ruby go 2>/dev/null
```

## Best Practices for OSCP Scripts

1. **Always include usage information** at the beginning of your scripts
2. **Validate user input** to prevent unexpected behavior
3. **Handle errors gracefully** with appropriate error messages
4. **Use comments** to explain complex logic
5. **Use functions** to organize code and avoid repetition
6. **Set appropriate permissions** for your scripts (`chmod +x script.sh`)
7. **Test your scripts thoroughly** before using them in critical operations
8. **Use portable code** that works across different Linux distributions
9. **Include cleanup mechanisms** to remove temporary files
10. **Document your scripts** with clear descriptions and examples
