# Command Line Practical Exercises

These exercises will help you develop command line skills essential for the OSCP exam. Complete them to build proficiency with Linux command line tools and techniques.

## Exercise 1: File System Navigation and Manipulation

**Objective:** Become proficient with file system navigation and basic file operations.

**Tasks:**
1. Create the following directory structure:
   ```
   ~/cmdline_practice/
   ├── data/
   │   ├── logs/
   │   └── configs/
   ├── scripts/
   ├── backups/
   └── temp/
   ```

2. Create the following files with appropriate content:
   - `~/cmdline_practice/data/configs/server.conf` - A simple configuration file
   - `~/cmdline_practice/data/logs/access.log` - A log file with at least 20 entries
   - `~/cmdline_practice/scripts/backup.sh` - A shell script that copies files from data to backups

3. Perform the following operations:
   - Find all `.log` files in the directory structure
   - Count the number of lines in all log files
   - Change permissions on the backup.sh script to make it executable
   - Create a symbolic link to the server.conf file in the home directory
   - Create a hard link to the access.log file in the temp directory

**Deliverable:** A shell script that performs all the above operations with appropriate comments.

## Exercise 2: Text Processing and Data Extraction

**Objective:** Learn to extract and manipulate data from text files using command line tools.

**Tasks:**
1. Create a file called `users.txt` with the following content:
   ```
   john:x:1001:1001:John Smith:/home/john:/bin/bash
   jane:x:1002:1002:Jane Doe:/home/jane:/bin/bash
   bob:x:1003:1003:Bob Johnson:/home/bob:/bin/zsh
   alice:x:1004:1004:Alice Williams:/home/alice:/bin/bash
   dave:x:1005:1005:Dave Brown:/home/dave:/bin/sh
   ```

2. Create a file called `access_log.txt` with at least 30 lines of web server access logs (you can generate sample data or use a real log format).

3. Using only command line tools, perform the following operations:
   - Extract only the usernames from users.txt
   - Extract only the shell types and count how many users use each shell
   - Find all lines in the access log containing "404" status codes
   - Extract all unique IP addresses from the access log
   - Count the occurrences of each HTTP status code in the access log
   - Find the top 5 most requested URLs in the access log

4. Create a one-liner command for each of the above tasks.

**Deliverable:** A text file containing all the commands used and their outputs.

## Exercise 3: Command Chaining and Pipelines

**Objective:** Master the art of combining commands to perform complex operations.

**Tasks:**
1. Create a file with 100 random numbers (one per line).

2. Using command chaining, perform the following operations:
   - Find the sum of all numbers
   - Find the average of all numbers
   - Find the median value
   - Find the 10 largest numbers
   - Find the 10 smallest numbers
   - Count how many numbers are greater than 50

3. Create a log file with entries containing timestamps, IP addresses, and status codes.

4. Using pipes and command chaining, perform the following operations:
   - Extract all entries from a specific date
   - Find all entries with error status codes (4xx or 5xx)
   - Count the number of requests per hour
   - Find the IP address with the most requests
   - Create a report showing the distribution of status codes

**Deliverable:** A shell script that performs all the above operations with appropriate comments explaining each command chain.

## Exercise 4: Regular Expressions and Pattern Matching

**Objective:** Develop proficiency with regular expressions for data extraction and validation.

**Tasks:**
1. Create a file containing the following types of data (at least 5 examples of each):
   - Email addresses
   - IP addresses
   - URLs
   - Phone numbers (various formats)
   - Credit card numbers (fake ones)
   - Social security numbers (fake ones)

2. Write grep commands with regular expressions to extract each type of data.

3. Write sed commands to transform:
   - Email addresses to the format "username AT domain DOT com"
   - Phone numbers to a standardized format (XXX-XXX-XXXX)
   - Mask credit card numbers (show only last 4 digits)
   - Mask social security numbers (show only last 4 digits)

4. Create a validation script that checks if a given string matches one of the patterns.

**Deliverable:** A shell script containing all the regular expressions and commands used for extraction and transformation.

## Exercise 5: Process Management and Monitoring

**Objective:** Learn to manage and monitor processes using command line tools.

**Tasks:**
1. Write a shell script that:
   - Starts 3 background processes (e.g., sleep commands with different durations)
   - Lists all running processes started by you
   - Identifies the process IDs
   - Terminates one process
   - Checks that it was terminated successfully

2. Create a monitoring script that:
   - Shows system load average
   - Shows memory usage
   - Shows disk usage
   - Shows network connections
   - Identifies the top 5 CPU-consuming processes
   - Identifies the top 5 memory-consuming processes

3. Create a script that simulates a CPU-intensive process and then:
   - Start the process in the background
   - Limit its CPU usage using nice or cpulimit
   - Verify that the limitation is working
   - Terminate the process

**Deliverable:** Two shell scripts: one for process management and one for system monitoring.

## Exercise 6: File Permissions and Ownership

**Objective:** Master Linux file permissions and ownership concepts.

**Tasks:**
1. Create a directory structure with various files and subdirectories.

2. Implement the following permission scenarios:
   - A directory that only the owner can enter but anyone can list its contents
   - A file that can be read by anyone but modified only by the owner
   - A script that can be executed by a specific group but not by others
   - A directory where any user can create files, but only the file creator can delete their own files (sticky bit)
   - A file with SUID permission
   - A directory with SGID permission

3. Create a script that:
   - Finds all SUID files in the system
   - Finds all SGID files in the system
   - Finds all world-writable files
   - Identifies files with unusual permissions

**Deliverable:** A shell script that sets up all the permission scenarios and another script that performs the permission auditing.

## Exercise 7: Bash Scripting Fundamentals

**Objective:** Develop basic bash scripting skills for automation.

**Tasks:**
1. Create a bash script that:
   - Takes command line arguments
   - Validates the number and type of arguments
   - Uses variables and environment variables
   - Implements conditional statements (if-else)
   - Implements loops (for, while)
   - Defines and uses functions
   - Handles errors and provides appropriate messages
   - Returns different exit codes based on execution results

2. The script should perform a practical task such as:
   - A simple port scanner
   - A log analyzer
   - A backup utility
   - A system information gatherer
   - A file search and categorization tool

3. Add proper documentation including:
   - Script purpose
   - Usage instructions
   - Examples
   - Error codes and their meanings

**Deliverable:** A well-documented bash script that implements all the required features.

## Exercise 8: Network Commands and Diagnostics

**Objective:** Learn to use command line tools for network diagnostics and information gathering.

**Tasks:**
1. Create a script that gathers the following information:
   - Local IP addresses and network interfaces
   - Routing table
   - DNS configuration
   - Active network connections
   - Listening ports
   - ARP table

2. Implement the following network diagnostics:
   - Ping sweep to find active hosts on a subnet
   - Port scan using bash (no nmap)
   - DNS lookups for a list of domains
   - Traceroute to multiple destinations
   - Check for common services (HTTP, SSH, FTP, etc.)

3. Create a network monitoring script that:
   - Monitors connectivity to a specified host
   - Alerts when the host goes down
   - Records response times
   - Generates a simple report

**Deliverable:** A set of shell scripts that perform the network information gathering, diagnostics, and monitoring tasks.

## Exercise 9: Input/Output Redirection and File Descriptors

**Objective:** Master input/output redirection and file descriptor manipulation.

**Tasks:**
1. Create a script that demonstrates:
   - Redirecting stdout to a file
   - Redirecting stderr to a file
   - Redirecting both stdout and stderr to different files
   - Redirecting both stdout and stderr to the same file
   - Redirecting stdout to stderr
   - Redirecting stderr to stdout
   - Using /dev/null to discard output

2. Create a script that uses file descriptors to:
   - Open a file for reading
   - Open a file for writing
   - Read from a custom file descriptor
   - Write to a custom file descriptor
   - Close file descriptors

3. Implement a logging function that:
   - Writes normal messages to stdout
   - Writes error messages to stderr
   - Writes debug messages to a log file
   - Allows controlling the verbosity level

**Deliverable:** A shell script that demonstrates all the I/O redirection techniques and file descriptor manipulations.

## Exercise 10: Command Line Efficiency Challenge

**Objective:** Apply all learned skills to solve complex problems efficiently.

**Tasks:**
1. You are given a large log file (create one with at least 1000 lines) containing web server access logs.

2. Using only command line tools, perform the following analyses:
   - Find the top 10 IP addresses by number of requests
   - Find the top 10 requested URLs
   - Identify all 404 errors and the URLs that caused them
   - Calculate the number of requests per hour
   - Identify potential scanning or brute force attacks (multiple failed requests)
   - Generate a summary report with all the above information

3. Create a script that monitors a log file in real-time and:
   - Alerts on error conditions
   - Blocks IP addresses with suspicious activity
   - Generates hourly statistics
   - Rotates and compresses old logs

**Deliverable:** A comprehensive shell script that performs all the required log analysis and monitoring tasks.

## Submission Guidelines

For each exercise:
1. Document your process thoroughly
2. Include all commands and scripts used
3. Explain your approach and any challenges encountered
4. Include sample outputs where appropriate

Remember, mastering the command line is essential for success in the OSCP exam. These exercises will help you develop the skills needed to efficiently navigate, analyze, and exploit target systems.
