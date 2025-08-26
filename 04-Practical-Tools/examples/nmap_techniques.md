# Nmap Scanning Techniques

Nmap (Network Mapper) is one of the most essential tools for network reconnaissance in penetration testing. This guide covers various Nmap scanning techniques relevant to OSCP.

## Basic Scanning Techniques

### Basic Scan
```bash
nmap 192.168.1.1
```
- Scans 1000 most common TCP ports
- Uses TCP SYN scan if run as root, TCP connect scan otherwise
- Performs DNS resolution, OS detection, version detection, and traceroute

### Scan Multiple Targets
```bash
# Scan multiple IP addresses
nmap 192.168.1.1 192.168.1.2 192.168.1.3

# Scan a range of IP addresses
nmap 192.168.1.1-10

# Scan an entire subnet
nmap 192.168.1.0/24

# Scan targets from a file
nmap -iL targets.txt
```

### Port Specification
```bash
# Scan specific ports
nmap -p 22,80,443 192.168.1.1

# Scan port ranges
nmap -p 1-100 192.168.1.1

# Scan all 65535 ports
nmap -p- 192.168.1.1

# Scan top 100 most common ports
nmap --top-ports 100 192.168.1.1

# Scan specific UDP ports
nmap -p U:53,161,162 192.168.1.1
```

## Scan Types

### TCP SYN Scan (Stealth Scan)
```bash
nmap -sS 192.168.1.1
```
- Default scan type when run as root
- Doesn't complete TCP connections, making it less noisy
- Faster than TCP connect scan

### TCP Connect Scan
```bash
nmap -sT 192.168.1.1
```
- Default scan type when run as non-root
- Completes the TCP three-way handshake
- More reliable but more detectable

### UDP Scan
```bash
nmap -sU 192.168.1.1
```
- Scans for UDP services (DNS, SNMP, DHCP)
- Much slower than TCP scans
- Often combined with TCP scanning: `nmap -sS -sU 192.168.1.1`

### TCP NULL, FIN, and Xmas Scans
```bash
# NULL scan - no flags set
nmap -sN 192.168.1.1

# FIN scan - only FIN flag set
nmap -sF 192.168.1.1

# Xmas scan - FIN, PSH, and URG flags set
nmap -sX 192.168.1.1
```
- Attempt to bypass simple firewall rules
- May work against Unix/Linux systems but often fail against Windows

### TCP ACK Scan
```bash
nmap -sA 192.168.1.1
```
- Used to map firewall rulesets
- Determines whether ports are filtered or unfiltered

### Custom Scan Flags
```bash
# Send custom TCP flags (SYN-FIN scan)
nmap --scanflags SYNFIN 192.168.1.1
```

## Service and OS Detection

### Service Version Detection
```bash
nmap -sV 192.168.1.1
```
- Detects service versions running on open ports
- Intensity can be set with `--version-intensity` (0-9)

### Operating System Detection
```bash
nmap -O 192.168.1.1
```
- Attempts to identify the operating system
- More accurate with more open/closed ports

### Combined Detection
```bash
nmap -sV -O 192.168.1.1
```

### Aggressive Scan
```bash
nmap -A 192.168.1.1
```
- Enables OS detection, version detection, script scanning, and traceroute
- Noisy but comprehensive

## NSE (Nmap Scripting Engine)

### Default Scripts
```bash
nmap -sC 192.168.1.1
```
- Runs default scripts (equivalent to `--script=default`)
- Safe scripts that provide valuable information

### Specific Scripts
```bash
nmap --script=http-title 192.168.1.1
```

### Script Categories
```bash
# Vulnerability detection
nmap --script=vuln 192.168.1.1

# Authentication scripts
nmap --script=auth 192.168.1.1

# Brute force scripts
nmap --script=brute 192.168.1.1

# Discovery scripts
nmap --script=discovery 192.168.1.1

# Safe scripts
nmap --script=safe 192.168.1.1
```

### Multiple Script Selection
```bash
nmap --script=http-enum,http-headers,http-methods 192.168.1.1
```

### Script with Arguments
```bash
nmap --script=http-brute --script-args userdb=users.txt,passdb=passwords.txt 192.168.1.1
```

## Timing and Performance

### Timing Templates
```bash
# Paranoid - Very slow, used for IDS evasion
nmap -T0 192.168.1.1

# Sneaky - Slow, used for IDS evasion
nmap -T1 192.168.1.1

# Polite - Slows down to consume less bandwidth
nmap -T2 192.168.1.1

# Normal - Default timing template
nmap -T3 192.168.1.1

# Aggressive - Assumes a fast and reliable network
nmap -T4 192.168.1.1

# Insane - Very aggressive, may overwhelm targets
nmap -T5 192.168.1.1
```

### Custom Timing Options
```bash
# Set minimum scan delay
nmap --scan-delay 1s 192.168.1.1

# Set maximum RTT timeout
nmap --max-rtt-timeout 100ms 192.168.1.1

# Set maximum retries
nmap --max-retries 2 192.168.1.1
```

## Output Options

### Output Formats
```bash
# Normal output to file
nmap -oN scan.txt 192.168.1.1

# XML output
nmap -oX scan.xml 192.168.1.1

# Grepable output
nmap -oG scan.grep 192.168.1.1

# All formats
nmap -oA scan 192.168.1.1
```

### Verbosity and Debugging
```bash
# Increase verbosity
nmap -v 192.168.1.1

# More verbosity
nmap -vv 192.168.1.1

# Debugging
nmap -d 192.168.1.1

# More debugging
nmap -dd 192.168.1.1
```

## Evasion Techniques

### Fragmentation
```bash
nmap -f 192.168.1.1
```
- Splits TCP headers into tiny fragments
- May evade some packet filtering

### MTU Specification
```bash
nmap --mtu 8 192.168.1.1
```
- Specifies custom MTU size
- Must be a multiple of 8

### Decoys
```bash
nmap -D 10.0.0.1,10.0.0.2,ME 192.168.1.1
```
- Makes the scan appear to come from multiple sources
- ME represents your real IP address in the decoy list

### Source Port Manipulation
```bash
nmap --source-port 53 192.168.1.1
```
- Spoofs the source port
- May bypass firewalls that allow traffic from specific ports (e.g., DNS)

### MAC Address Spoofing
```bash
nmap --spoof-mac 00:11:22:33:44:55 192.168.1.1
```
- Spoofs the MAC address for local network scans
- Can also use vendor names: `--spoof-mac Cisco`

### Data Length Manipulation
```bash
nmap --data-length 200 192.168.1.1
```
- Appends random data to packets
- Helps avoid detection by packet length

## OSCP-Relevant Scanning Strategies

### Initial Reconnaissance
```bash
# Quick scan of top ports
nmap -T4 --top-ports 10 192.168.1.0/24
```
- Quickly identifies live hosts and common services
- Good starting point for large networks

### Comprehensive Host Scan
```bash
nmap -sS -sV -sC -p- -oA full_scan 192.168.1.1
```
- Full TCP port scan with service detection and default scripts
- Thorough but time-consuming

### UDP Services Scan
```bash
nmap -sU -sV --top-ports 20 192.168.1.1
```
- Scans top UDP ports with version detection
- Important for services like DNS, SNMP, TFTP

### Vulnerability Assessment
```bash
nmap --script=vuln -p 22,80,443,445 192.168.1.1
```
- Checks for known vulnerabilities on specific ports
- May identify potential exploitation vectors

### Web Server Enumeration
```bash
nmap -p 80,443 --script=http-enum,http-headers,http-methods,http-title 192.168.1.1
```
- Enumerates web server information
- Identifies potential web application entry points

### SMB Enumeration
```bash
nmap -p 445 --script=smb-os-discovery,smb-enum-shares,smb-enum-users,smb-protocols 192.168.1.1
```
- Gathers information about SMB services
- Identifies potential Windows exploitation vectors

## Practical Examples for OSCP

### Example 1: Initial Network Sweep
```bash
# Identify live hosts
nmap -sn 192.168.1.0/24

# Quick port scan of discovered hosts
nmap -T4 -F $(grep "up" initial_sweep.txt | cut -d " " -f 2)
```

### Example 2: Targeted Service Enumeration
```bash
# Discover web servers
nmap -p 80,443,8080,8443 192.168.1.0/24 -oG web_servers.txt

# Enumerate discovered web servers
for ip in $(grep "open" web_servers.txt | cut -d " " -f 2); do
  nmap -sV -p 80,443,8080,8443 --script=http-enum,http-headers $ip -oN web_enum_$ip.txt
done
```

### Example 3: Vulnerability Scanning Workflow
```bash
# Initial scan
nmap -sV -p- 192.168.1.1 -oA initial_scan

# Target specific services for vulnerability checks
ports=$(grep "open" initial_scan.gnmap | cut -d " " -f 4 | tr -d "/open/tcp//")
nmap -sV -p $ports --script=vuln 192.168.1.1 -oA vuln_scan
```

## Tips for OSCP Success

1. **Start broad, then narrow down**: Begin with quick scans of the entire network, then focus on interesting hosts and services.

2. **Always scan all ports**: Use `-p-` for full port scans on promising targets, as CTF-style challenges often use non-standard ports.

3. **Save your results**: Always use output options (`-oA`) to save scan results for later reference and reporting.

4. **Be patient with UDP scans**: UDP scans are slow but can reveal critical services. Focus on common UDP ports if a full scan is too time-consuming.

5. **Use NSE scripts wisely**: NSE scripts can provide valuable information but can be noisy and time-consuming. Select relevant scripts rather than running all of them.

6. **Respect the exam environment**: Avoid aggressive scanning techniques that might disrupt the exam environment.

7. **Verify findings manually**: Don't rely solely on automated scans; verify findings manually to avoid false positives.

8. **Combine Nmap with other tools**: Use Nmap results to guide further enumeration with specialized tools like gobuster, enum4linux, or SMBMap.
