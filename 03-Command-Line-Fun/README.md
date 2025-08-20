# Command Line Fun

[← Back to Main Menu](../readme.md) | [Next Module: Practical Tools →](../04-Practical-Tools/)

## Overview

The command line is a powerful interface that allows direct interaction with the operating system. For penetration testers, mastering the command line is essential as it provides flexibility, speed, and capabilities that graphical interfaces often lack. This module will help you become proficient with the Linux command line, focusing on tools and techniques relevant to the OSCP exam.

## Learning Objectives

By the end of this module, you will be able to:
- Navigate the Linux file system efficiently using command line tools
- Manipulate files and directories with precision
- Process text and data using command line utilities
- Create and execute basic shell scripts
- Use command line tools for network reconnaissance and information gathering
- Chain commands together to create powerful one-liners
- Understand input/output redirection and piping

## Key Concepts

### 1. Basic Navigation and File Operations

```bash
# Directory navigation
pwd                 # Print working directory
ls -la              # List all files with details
cd /path/to/dir     # Change directory
find / -name file   # Find files by name

# File operations
cp source dest      # Copy files
mv source dest      # Move/rename files
rm -rf file/dir     # Remove files/directories
mkdir -p dir        # Create directories
touch file          # Create empty file
```

### 2. Text Processing Tools

```bash
# Viewing file content
cat file            # Display file content
less file           # View file with pagination
head -n 10 file     # Show first 10 lines
tail -n 10 file     # Show last 10 lines
tail -f file        # Follow file updates in real-time

# Text processing
grep pattern file   # Search for pattern in file
sed 's/old/new/g'   # Stream editor for text substitution
awk '{print $1}'    # Pattern scanning and processing
sort file           # Sort lines in file
uniq                # Report or filter out repeated lines
```

### 3. Input/Output Redirection and Pipes

```bash
# Redirection
command > file      # Redirect stdout to file (overwrite)
command >> file     # Redirect stdout to file (append)
command 2> file     # Redirect stderr to file
command &> file     # Redirect both stdout and stderr

# Pipes
command1 | command2 # Pipe output of command1 to command2
command1 | tee file # Send output to both file and screen
```

### 4. Process Management

```bash
# Process viewing
ps aux              # List all processes
top                 # Dynamic process viewer
htop                # Enhanced version of top

# Process control
kill PID            # Kill process by ID
killall process     # Kill process by name
bg                  # Send process to background
fg                  # Bring process to foreground
jobs                # List background jobs
```

### 5. Networking Commands

```bash
# Network information
ifconfig / ip a     # Show network interfaces
netstat -tuln       # Show listening ports
ss -tuln            # Modern alternative to netstat
route               # Show routing table

# Network connectivity
ping host           # Test connectivity
traceroute host     # Trace route to host
dig domain          # DNS lookup
host domain         # DNS lookup
whois domain        # Domain registration info
```

### 6. File Transfer and Remote Access

```bash
# Secure copy
scp file user@host:/path  # Copy file to remote host
scp user@host:/path file  # Copy file from remote host

# SSH
ssh user@host             # Connect to remote host
ssh -i key.pem user@host  # Connect using key file
ssh-keygen                # Generate SSH key pair

# Web transfers
wget URL                  # Download file from web
curl URL                  # Transfer data from/to server
```

### 7. Command Chaining and Control Operators

```bash
# Command chaining
command1 ; command2       # Run command1 then command2
command1 && command2      # Run command2 only if command1 succeeds
command1 || command2      # Run command2 only if command1 fails
(command1 ; command2)     # Group commands together
```

### 8. Command Substitution and Variables

```bash
# Command substitution
$(command)                # Execute command and substitute output
`command`                 # Older syntax for command substitution

# Variables
VAR="value"               # Set variable
echo $VAR                 # Use variable
export VAR                # Make variable available to child processes
```

## OSCP Relevance

In the OSCP exam, you'll need to:
- Navigate unfamiliar systems quickly and efficiently
- Process large amounts of data to find vulnerabilities
- Create and modify scripts on the fly
- Transfer files between systems
- Chain commands together for efficient reconnaissance
- Parse output from various tools to extract useful information

The command line is your primary interface during the exam, and proficiency with it will save you valuable time and effort.

## Common Pitfalls

- **Forgetting to use sudo**: Many commands require elevated privileges
- **Not using tab completion**: Tab completion saves time and prevents typos
- **Ignoring command history**: Use up/down arrows or CTRL+R to search history
- **Not using man pages**: Man pages provide detailed information about commands
- **Overlooking command options**: Many commands have useful options that can simplify tasks

## Additional Resources

- [Linux Command Line Cheat Sheet](https://cheatography.com/davechild/cheat-sheets/linux-command-line/)
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Explainshell](https://explainshell.com/) - Explains shell commands

## Practical Application

Check out the [examples](./examples/) directory for practical demonstrations of command line techniques, the [exercises](./exercises/) directory for hands-on practice, and the [resources](./resources/) directory for additional tools and scripts.

Remember, the key to mastering the command line is practice. Try to use the command line for your daily tasks, and gradually incorporate more advanced commands and techniques into your workflow.

[← Back to Main Menu](../readme.md) | [Next Module: Practical Tools →](../04-Practical-Tools/)
