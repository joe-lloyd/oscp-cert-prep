# Text Processing Examples

This document provides practical examples of text processing commands that are useful for penetration testing and the OSCP exam.

## Grep - Pattern Matching

### Basic Usage

```bash
# Search for a string in a file
grep "password" /etc/passwd

# Case-insensitive search
grep -i "admin" config.php

# Show line numbers
grep -n "root" /etc/passwd

# Recursive search in directory
grep -r "password" /var/www/

# Show only the matching part
grep -o "password[^']*" config.php

# Count matches
grep -c "Failed password" /var/log/auth.log

# Invert match (show lines that don't match)
grep -v "^#" /etc/ssh/sshd_config
```

### Advanced Grep with Regular Expressions

```bash
# Match IP addresses
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log

# Match email addresses
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" users.txt

# Match URLs
grep -E "https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[/a-zA-Z0-9._%+-]*" links.txt

# Match password fields in HTML/JS
grep -E "password[[:space:]]*=[[:space:]]*['\"][^'\"]*['\"]" *.js

# Match SSH private keys
grep -r "BEGIN RSA PRIVATE KEY" /home/
```

## Sed - Stream Editor

### Basic Text Substitution

```bash
# Replace first occurrence of a pattern in each line
sed 's/password/p@ssw0rd/' config.txt

# Replace all occurrences of a pattern in each line
sed 's/password/p@ssw0rd/g' config.txt

# Replace pattern only on lines that match
sed '/admin/s/password/p@ssw0rd/g' config.txt

# Delete lines matching a pattern
sed '/^#/d' config.txt

# Print only lines matching a pattern
sed -n '/password/p' config.txt
```

### Advanced Sed Usage

```bash
# Multiple operations
sed -e 's/foo/bar/g' -e 's/baz/qux/g' file.txt

# Replace with capture groups
sed 's/user=\([^&]*\)/user=admin\1/' url.txt

# Insert line before match
sed '/^<\/head>/ i\<script src="malicious.js"></script>' index.html

# Append line after match
sed '/^<body>/ a\<div>Hacked!</div>' index.html

# Replace in specific line range
sed '10,20 s/old/new/g' file.txt
```

## Awk - Pattern Scanning and Processing

### Basic Field Processing

```bash
# Print specific columns (space-delimited)
awk '{print $1, $3}' file.txt

# Print specific columns (custom delimiter)
awk -F: '{print $1, $3}' /etc/passwd

# Sum values in a column
awk '{sum += $3} END {print sum}' numbers.txt

# Print lines where a field meets a condition
awk '$3 > 1000 {print $0}' data.txt

# Print line number and content
awk '{print NR, $0}' file.txt
```

### Advanced Awk Usage

```bash
# Process Apache logs to extract IP addresses and URLs
awk '{print $1, $7}' access.log

# Count occurrences of each IP in a log file
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' access.log

# Calculate average of values in column 3
awk '{sum += $3; count++} END {print sum/count}' data.txt

# Extract usernames from /etc/passwd
awk -F: '{print $1}' /etc/passwd

# Format output with printf
awk '{printf "%-15s %-8s %s\n", $1, $2, $3}' data.txt
```

## Cut - Extract Sections from Lines

```bash
# Extract characters by position
cut -c 1-10 file.txt

# Extract fields by delimiter
cut -d: -f1,3,7 /etc/passwd

# Extract fields and change output delimiter
cut -d: -f1,3 --output-delimiter=' -> ' /etc/passwd
```

## Sort - Sort Lines of Text

```bash
# Basic sorting
sort file.txt

# Numeric sort
sort -n numbers.txt

# Reverse sort
sort -r file.txt

# Sort by specific field (space-delimited)
sort -k2 file.txt

# Sort by specific field with custom delimiter
sort -t: -k3 -n /etc/passwd
```

## Uniq - Report or Filter Repeated Lines

```bash
# Show unique lines (must be sorted first)
sort file.txt | uniq

# Count occurrences of each line
sort file.txt | uniq -c

# Show only duplicate lines
sort file.txt | uniq -d

# Show only lines that appear exactly once
sort file.txt | uniq -u
```

## Practical Combinations for Penetration Testing

### Extract Unique IP Addresses from a Log File

```bash
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log | sort | uniq
```

### Find the Top 10 IP Addresses in a Log File

```bash
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log | sort | uniq -c | sort -nr | head -n 10
```

### Extract All Email Addresses from Multiple Files

```bash
grep -r -Eo "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" /path/to/files/ | sort | uniq
```

### Find Files Containing Passwords

```bash
grep -l -r "password\|passwd\|pwd" /var/www/
```

### Extract Usernames and Password Hashes from /etc/shadow

```bash
grep -v '^[^:]*:[\*!]' /etc/shadow | cut -d: -f1,2
```

### Parse Nmap XML Output

```bash
grep -oP '<port protocol="tcp" portid="\K[0-9]+(?=")' nmap_scan.xml | sort -n
```

### Extract URLs from JavaScript Files

```bash
grep -r -Eo "(https?|ftp)://[a-zA-Z0-9./?=_-]*" --include="*.js" /var/www/
```

### Find Potential SQL Injection Points in Logs

```bash
grep -E "('|%27|--|;|/\*|\*/)" access.log
```

### Extract All Unique User-Agents from Logs

```bash
grep -oP '"User-Agent: \K[^"]*' access.log | sort | uniq
```

### Find Files Modified in the Last 24 Hours

```bash
find /var/www -type f -mtime -1 | xargs ls -la
```

## OSCP Exam Relevance

During the OSCP exam, you'll need to process large amounts of data quickly to identify potential vulnerabilities. These text processing commands will help you:

1. Parse scan results to identify targets
2. Extract useful information from configuration files
3. Search for sensitive data like passwords and keys
4. Analyze log files for signs of vulnerability
5. Format data for inclusion in your report
6. Create custom wordlists for password attacks
7. Filter out noise to focus on relevant information

Remember that combining these tools with pipes (`|`) creates powerful one-liners that can save you significant time during the exam.
