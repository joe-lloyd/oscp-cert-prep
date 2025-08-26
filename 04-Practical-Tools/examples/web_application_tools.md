# Web Application Testing Tools

This guide covers essential web application testing tools and techniques for OSCP. Web applications are common targets in penetration testing, and understanding how to effectively use these tools is crucial for success.

## Directory and File Enumeration

### Gobuster

Gobuster is a tool used to brute-force URIs (directories and files) in web sites, DNS subdomains, and virtual host names.

#### Basic Directory Scanning
```bash
# Basic directory scan
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# With file extensions
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -x php,txt,html

# With status code filtering
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -s 200,204,301,302,307,403

# With custom user-agent
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -a "Mozilla/5.0"

# With HTTP authentication
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -U admin -P password
```

#### DNS Subdomain Enumeration
```bash
gobuster dns -d target.com -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
```

#### Virtual Host Discovery
```bash
gobuster vhost -u http://target.com -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
```

### Dirbuster/Dirb

Dirb is another web content scanner that looks for existing (and/or hidden) web objects.

```bash
# Basic scan
dirb http://target.com

# With custom wordlist
dirb http://target.com /usr/share/wordlists/dirb/big.txt

# With file extensions
dirb http://target.com /usr/share/wordlists/dirb/common.txt -X .php,.txt,.html

# With authentication
dirb http://target.com /usr/share/wordlists/dirb/common.txt -u admin:password
```

### Feroxbuster

Feroxbuster is a fast, simple, recursive content discovery tool.

```bash
# Basic scan
feroxbuster --url http://target.com

# Recursive scan with depth
feroxbuster --url http://target.com --depth 3

# With extensions
feroxbuster --url http://target.com --extensions php,txt,html

# With filters
feroxbuster --url http://target.com --filter-status 301,302

# Parallel scanning
feroxbuster --url http://target.com --parallel 10
```

## Web Proxies

### Burp Suite

Burp Suite is an integrated platform for performing security testing of web applications.

#### Key Features
1. **Proxy**: Intercept and modify requests/responses
2. **Spider**: Crawl web applications
3. **Repeater**: Manually modify and resend requests
4. **Intruder**: Automated attacks
5. **Scanner**: Automated vulnerability detection (Pro version)
6. **Sequencer**: Test randomness of session tokens
7. **Decoder**: Encode/decode data
8. **Comparer**: Compare data sets

#### Basic Usage
1. Configure browser to use Burp proxy (default: 127.0.0.1:8080)
2. Intercept requests in Proxy tab
3. Send interesting requests to other tools (right-click > Send to...)
4. Use Repeater to modify and test requests

#### Common Tasks
```
# Testing for SQL injection
1. Intercept a request with a parameter
2. Send to Repeater
3. Add SQL injection payloads to parameters
4. Analyze responses for errors or unexpected behavior

# Testing for XSS
1. Intercept a request with a parameter
2. Send to Repeater
3. Add XSS payloads like <script>alert(1)</script>
4. Check if payload is reflected in the response

# Session token analysis
1. Capture multiple session tokens
2. Send to Sequencer
3. Analyze randomness and predictability
```

### OWASP ZAP

ZAP (Zed Attack Proxy) is a free, open-source web application security scanner.

#### Key Features
1. **Intercepting Proxy**
2. **Automated Scanner**
3. **Passive Scanner**
4. **Spider**
5. **Fuzzer**
6. **Web API Support**

#### Basic Usage
```bash
# Start ZAP GUI
zaproxy

# Command line quick scan
zap-cli quick-scan --self-contained --start-options "-config api.disablekey=true" http://target.com
```

## SQL Injection Tools

### SQLmap

SQLmap is an open-source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws.

#### Basic Usage
```bash
# Test a URL parameter
sqlmap -u "http://target.com/page.php?id=1"

# Test with cookies (e.g., after authentication)
sqlmap -u "http://target.com/page.php?id=1" --cookie="PHPSESSID=1234abcd"

# Test all parameters
sqlmap -u "http://target.com/page.php?id=1&page=2" --forms --batch

# Test a POST request (saved from Burp)
sqlmap -r request.txt

# Specify a parameter to test
sqlmap -u "http://target.com/page.php" --data="id=1&user=admin" -p id
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
# Use a specific technique (B: Boolean-based, E: Error-based, U: Union-based, S: Stacked queries, T: Time-based)
sqlmap -u "http://target.com/page.php?id=1" --technique=BEU

# Specify database type
sqlmap -u "http://target.com/page.php?id=1" --dbms=mysql

# Get OS shell
sqlmap -u "http://target.com/page.php?id=1" --os-shell

# Get SQL shell
sqlmap -u "http://target.com/page.php?id=1" --sql-shell

# Get file system access
sqlmap -u "http://target.com/page.php?id=1" --file-read="/etc/passwd"
```

## Web Fuzzing Tools

### Wfuzz

Wfuzz is a web application fuzzer that can be used to find resources, parameters, and other hidden content by using brute force methods.

#### Basic Usage
```bash
# Fuzz URL parameters
wfuzz -c -z file,/usr/share/wordlists/wfuzz/general/common.txt http://target.com/FUZZ

# Fuzz parameter values
wfuzz -c -z file,/usr/share/wordlists/wfuzz/general/common.txt http://target.com/index.php?id=FUZZ

# Multiple parameter fuzzing
wfuzz -c -z file,users.txt -z file,passwords.txt http://target.com/login.php?user=FUZZ&pass=FUZ2Z

# POST request fuzzing
wfuzz -c -z file,users.txt -z file,passwords.txt -d "username=FUZZ&password=FUZ2Z" http://target.com/login.php
```

#### Filtering Results
```bash
# Filter by response code
wfuzz -c -z file,wordlist.txt --hc 404 http://target.com/FUZZ

# Filter by word count
wfuzz -c -z file,wordlist.txt --hw 42 http://target.com/FUZZ

# Filter by character count
wfuzz -c -z file,wordlist.txt --hh 2571 http://target.com/FUZZ
```

### FFuF (Fuzz Faster U Fool)

FFuF is a fast web fuzzer written in Go.

```bash
# Directory discovery
ffuf -w /usr/share/wordlists/dirb/common.txt -u http://target.com/FUZZ

# Extension fuzzing
ffuf -w /usr/share/wordlists/dirb/common.txt -u http://target.com/FUZZ.php

# Parameter fuzzing
ffuf -w /usr/share/wordlists/dirb/common.txt -u http://target.com/index.php?FUZZ=value

# Value fuzzing
ffuf -w /usr/share/wordlists/dirb/common.txt -u http://target.com/index.php?param=FUZZ

# POST data fuzzing
ffuf -w /usr/share/wordlists/dirb/common.txt -X POST -d "username=admin&password=FUZZ" -u http://target.com/login
```

## XSS Testing Tools

### XSSer

XSSer is an automatic framework to detect, exploit and report XSS vulnerabilities.

```bash
# Basic scan
xsser --url "http://target.com/page.php?id=1"

# With GET parameters
xsser -u "http://target.com/page.php" --get="id=XSS"

# With POST parameters
xsser -u "http://target.com/page.php" --post="id=XSS"

# With cookies
xsser -u "http://target.com/page.php" --cookie="PHPSESSID=1234abcd" --get="id=XSS"
```

### XSS Payloads

Common XSS payloads for manual testing:

```html
<!-- Basic alert -->
<script>alert('XSS')</script>

<!-- Image-based XSS -->
<img src="x" onerror="alert('XSS')">

<!-- JavaScript event handlers -->
<body onload="alert('XSS')">

<!-- JavaScript URI -->
<a href="javascript:alert('XSS')">Click me</a>

<!-- DOM-based XSS -->
<script>document.write("<img src='x' onerror='alert(\"XSS\")'>");</script>
```

## CMS Scanners

### WPScan (WordPress)

WPScan is a black box WordPress vulnerability scanner.

```bash
# Basic scan
wpscan --url http://target.com

# Enumerate users
wpscan --url http://target.com --enumerate u

# Enumerate vulnerable plugins
wpscan --url http://target.com --enumerate vp

# Enumerate all plugins
wpscan --url http://target.com --enumerate ap

# Password brute force
wpscan --url http://target.com --passwords /path/to/wordlist.txt --usernames admin
```

### Droopescan (Drupal)

```bash
# Basic scan
droopescan scan drupal -u http://target.com

# With authentication
droopescan scan drupal -u http://target.com -a "admin:password"
```

### Joomscan (Joomla)

```bash
# Basic scan
joomscan -u http://target.com

# With enumeration
joomscan -u http://target.com -ec
```

## API Testing Tools

### Postman

Postman is a popular API client that makes it easy to create, share, test, and document APIs.

#### Key Features
1. Request builder
2. Collections for organizing requests
3. Environment variables
4. Automated testing
5. Documentation generation

### Swagger/OpenAPI Tools

```bash
# Swagger UI Docker container
docker run -p 8080:8080 -e SWAGGER_JSON=/foo/swagger.json -v /bar:/foo swaggerapi/swagger-ui
```

## OSCP-Relevant Web Testing Methodology

### 1. Reconnaissance
- Identify web servers with Nmap
- Check for common web ports (80, 443, 8080, 8443)
- Identify web technologies with Wappalyzer or Whatweb

### 2. Content Discovery
- Use Gobuster/Dirb for directory enumeration
- Check for common files (robots.txt, sitemap.xml)
- Look for backup files (.bak, .old, .backup)
- Identify CMS and use specialized scanners

### 3. Vulnerability Assessment
- Check for default credentials
- Test for SQL injection with SQLmap
- Test for XSS vulnerabilities
- Check for file inclusion vulnerabilities
- Test file upload functionality

### 4. Authentication Testing
- Test for weak passwords
- Check for authentication bypasses
- Test password reset functionality
- Check session management

### 5. Authorization Testing
- Test access controls
- Check for insecure direct object references
- Test for privilege escalation

### 6. Exploitation
- Exploit identified vulnerabilities
- Upload web shells
- Establish persistence
- Escalate privileges

## OSCP Exam Tips

1. **Start with basic enumeration**: Always begin with thorough directory and file enumeration.

2. **Check for common vulnerabilities**: Focus on SQL injection, XSS, file inclusion, and file upload vulnerabilities.

3. **Document everything**: Keep detailed notes of all findings and tests performed.

4. **Manual verification**: Always manually verify automated tool findings to avoid false positives.

5. **Look for custom applications**: Custom web applications often have unique vulnerabilities not detected by automated tools.

6. **Check source code**: Review page source code for hidden fields, comments, and JavaScript that might reveal vulnerabilities.

7. **Test all input fields**: Every input field is a potential entry point for attacks.

8. **Use Burp Suite effectively**: Intercept and analyze all requests to understand the application's behavior.

9. **Combine tools**: Use multiple tools together for comprehensive testing.

10. **Be persistent**: Web applications often have multiple layers of security; keep testing methodically.
