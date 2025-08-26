# Practical Tools for OSCP

This module covers essential practical tools used during penetration testing and the OSCP exam. You'll learn how to use, customize, and chain together various security tools to efficiently identify and exploit vulnerabilities.

## Learning Objectives

By the end of this module, you will be able to:

- Understand and use key penetration testing tools in Kali Linux
- Customize tools for specific penetration testing scenarios
- Interpret tool output and identify actionable information
- Chain multiple tools together for effective reconnaissance and exploitation
- Troubleshoot common tool issues and limitations

## Table of Contents

1. [Information Gathering Tools](#information-gathering-tools)
2. [Vulnerability Assessment Tools](#vulnerability-assessment-tools)
3. [Web Application Tools](#web-application-tools)
4. [Exploitation Tools](#exploitation-tools)
5. [Post-Exploitation Tools](#post-exploitation-tools)
6. [Password Attacks and Cracking Tools](#password-attacks-and-cracking-tools)
7. [Custom Tool Development](#custom-tool-development)

## Information Gathering Tools

### Network Scanning
- **Nmap**: Port scanning, service enumeration, OS detection
- **Masscan**: Fast port scanning for large networks
- **Netdiscover**: ARP reconnaissance tool

### DNS Enumeration
- **dig/nslookup/host**: DNS query tools
- **DNSRecon**: Advanced DNS enumeration
- **Sublist3r**: Subdomain enumeration

### OSINT Tools
- **theHarvester**: Email, subdomain, and people gathering
- **Recon-ng**: Web reconnaissance framework
- **Maltego**: Interactive data mining

## Vulnerability Assessment Tools

### Network Vulnerability Scanners
- **OpenVAS**: Open Vulnerability Assessment System
- **Nessus Essentials**: Vulnerability scanner (free version)
- **Nikto**: Web server scanner

### Specific Vulnerability Checks
- **SMBMap**: SMB enumeration tool
- **enum4linux**: Windows/Samba enumeration
- **WPScan**: WordPress vulnerability scanner

## Web Application Tools

### Web Proxies
- **Burp Suite**: Web application security testing
- **OWASP ZAP**: Open-source web app scanner
- **Mitmproxy**: Interactive HTTPS proxy

### Web Crawlers and Fuzzers
- **Gobuster/Dirbuster**: Directory brute forcing
- **Wfuzz**: Web application fuzzer
- **SQLmap**: SQL injection automation

## Exploitation Tools

### Exploitation Frameworks
- **Metasploit Framework**: Exploitation development and execution
- **SearchSploit**: Exploit-DB command line search tool
- **BeEF**: Browser Exploitation Framework

### Manual Exploitation
- **Reverse shell techniques**: Netcat, Socat, Python
- **Web shells**: PHP, ASP, JSP
- **Buffer overflow tools**: Pattern creation, offset calculation

## Post-Exploitation Tools

### Privilege Escalation
- **LinPEAS/WinPEAS**: Privilege escalation scripts
- **Linux Smart Enumeration**: System enumeration
- **PowerUp/PowerView**: Windows privilege escalation

### Lateral Movement
- **Impacket**: Network protocol toolkit
- **CrackMapExec**: Network lateral movement
- **Evil-WinRM**: Windows Remote Management

## Password Attacks and Cracking Tools

### Password Cracking
- **Hashcat**: Advanced password recovery
- **John the Ripper**: Password cracking
- **Hydra**: Online password attacks

### Password Dumping
- **Mimikatz**: Windows credential dumping
- **Responder**: LLMNR/NBT-NS/mDNS poisoning
- **Secretsdump**: Remote SAM/LSA dumping

## Custom Tool Development

### Tool Customization
- **Modifying existing tools**: Adapting to specific needs
- **Scripting with Python**: Automating penetration testing tasks
- **Bash scripting**: Chaining tools together

### Tool Creation
- **Building custom scanners**: Specific vulnerability checks
- **Exploit development**: Creating targeted exploits
- **Reporting tools**: Automating documentation

## Practical Approach

For each tool category, we will:
1. Understand the tool's purpose and capabilities
2. Learn basic and advanced usage
3. Practice with realistic scenarios
4. Interpret results and take appropriate next steps
5. Understand limitations and alternatives

## OSCP Exam Relevance

The OSCP exam requires proficiency with various tools, but more importantly, it tests your ability to:
- Select the right tool for each task
- Understand tool output and identify important information
- Troubleshoot when tools don't work as expected
- Modify or chain tools when standard approaches fail

Remember that in the OSCP exam, fully automated tools like vulnerability scanners have limited use. Focus on understanding the manual techniques and targeted tool usage that will help you identify and exploit vulnerabilities methodically.

## Additional Resources

- Check the [examples](./examples/) directory for detailed tool usage examples
- Complete the [exercises](./exercises/) to practice your skills
- Explore the [resources](./resources/) directory for additional tools and scripts

## Next Steps

After completing this module, you should be comfortable with the core tools used in penetration testing. The next modules will build on this knowledge to explore specific attack vectors and techniques in depth.
