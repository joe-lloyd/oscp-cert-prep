# Nmap Cheatsheet for OSCP

## Basic Scans

### Quick Scan
```bash
nmap <target>
```

### Scan Multiple Targets
```bash
nmap <target1> <target2> <target3>
nmap 192.168.1.1-254
nmap 192.168.1.0/24
```

### Scan from File
```bash
nmap -iL targets.txt
```

### Exclude Hosts
```bash
nmap 192.168.1.0/24 --exclude 192.168.1.5,192.168.1.254
```

## Port Specification

### Scan Specific Ports
```bash
nmap -p 80,443,3389 <target>
```

### Scan Port Ranges
```bash
nmap -p 1-1000 <target>
```

### Scan All Ports
```bash
nmap -p- <target>
```

### Scan Top Ports
```bash
nmap --top-ports 100 <target>
```

### Scan UDP Ports
```bash
nmap -sU <target>
nmap -sU -p 53,161,162 <target>
```

## Scan Types

### TCP SYN Scan (Default)
```bash
nmap -sS <target>
```

### TCP Connect Scan
```bash
nmap -sT <target>
```

### UDP Scan
```bash
nmap -sU <target>
```

### TCP NULL Scan
```bash
nmap -sN <target>
```

### TCP FIN Scan
```bash
nmap -sF <target>
```

### TCP XMAS Scan
```bash
nmap -sX <target>
```

### TCP ACK Scan
```bash
nmap -sA <target>
```

### TCP Window Scan
```bash
nmap -sW <target>
```

### TCP Maimon Scan
```bash
nmap -sM <target>
```

### Idle/Zombie Scan
```bash
nmap -sI <zombie_host> <target>
```

## Service and OS Detection

### Service Version Detection
```bash
nmap -sV <target>
```

### OS Detection
```bash
nmap -O <target>
```

### Aggressive Scan (OS + Version + Scripts + Traceroute)
```bash
nmap -A <target>
```

### Detect Service/Version with Light Intensity
```bash
nmap -sV --version-intensity 0 <target>
```

### Detect Service/Version with Maximum Intensity
```bash
nmap -sV --version-intensity 9 <target>
```

## NSE Scripts

### Default Scripts
```bash
nmap -sC <target>
```

### Specific Script
```bash
nmap --script=<script-name> <target>
```

### Script Categories
```bash
nmap --script=auth <target>
nmap --script=vuln <target>
nmap --script=exploit <target>
nmap --script=discovery <target>
```

### Multiple Script Categories
```bash
nmap --script=auth,vuln <target>
```

### All Scripts (Caution: Very Noisy)
```bash
nmap --script=all <target>
```

### Script with Arguments
```bash
nmap --script=http-title <target>
nmap --script=http-enum <target>
nmap --script=smb-os-discovery <target>
nmap --script=dns-zone-transfer --script-args dns-zone-transfer.domain=example.com <target>
```

## OSCP-Relevant Scripts

### SMB Enumeration
```bash
nmap --script=smb-enum-shares,smb-enum-users <target>
nmap --script=smb-vuln* <target>
```

### Web Application Scanning
```bash
nmap --script=http-enum <target>
nmap --script=http-title,http-headers <target>
nmap --script=http-methods --script-args http-methods.test=all <target>
```

### SSL/TLS Testing
```bash
nmap --script=ssl-enum-ciphers <target>
```

### Brute Force Authentication
```bash
nmap --script=ftp-brute <target>
nmap --script=ssh-brute <target>
```

## Timing and Performance

### Timing Templates
```bash
nmap -T0 <target>  # Paranoid - Very slow, used for IDS evasion
nmap -T1 <target>  # Sneaky - Slow, used for IDS evasion
nmap -T2 <target>  # Polite - Slows down to consume less bandwidth
nmap -T3 <target>  # Normal - Default speed
nmap -T4 <target>  # Aggressive - Faster, assumes reliable network
nmap -T5 <target>  # Insane - Very fast, assumes extremely reliable network
```

### Custom Timing
```bash
nmap --min-hostgroup 100 --max-hostgroup 500 <target>
nmap --min-parallelism 10 --max-parallelism 30 <target>
nmap --min-rtt-timeout 300ms --max-rtt-timeout 500ms <target>
nmap --initial-rtt-timeout 300ms <target>
nmap --max-retries 2 <target>
nmap --host-timeout 30m <target>
nmap --scan-delay 1s <target>
```

## Output Options

### Save to All Formats
```bash
nmap -oA output_file <target>
```

### Save to Normal Format
```bash
nmap -oN output.txt <target>
```

### Save to XML Format
```bash
nmap -oX output.xml <target>
```

### Save to Grepable Format
```bash
nmap -oG output.grep <target>
```

### Verbose Output
```bash
nmap -v <target>
nmap -vv <target>  # More verbose
```

### Debug Output
```bash
nmap -d <target>
nmap -dd <target>  # More debugging
```

## Evasion Techniques

### Fragmented Packets
```bash
nmap -f <target>
nmap -ff <target>  # More fragmentation
```

### Specify MTU
```bash
nmap --mtu 8 <target>
```

### Decoy Scan
```bash
nmap -D RND:10 <target>  # 10 random decoys
nmap -D 10.0.0.1,10.0.0.2,ME <target>  # Specific decoys
```

### Spoof Source IP
```bash
nmap -S 10.0.0.1 <target>
```

### Spoof Source Port
```bash
nmap -g 53 <target>
```

### Use Random Data to Payloads
```bash
nmap --data-length 200 <target>
```

### MAC Address Spoofing
```bash
nmap --spoof-mac 00:11:22:33:44:55 <target>
nmap --spoof-mac 0 <target>  # Random MAC
nmap --spoof-mac Apple <target>  # Vendor specific MAC
```

### Send Bad Checksums
```bash
nmap --badsum <target>
```

## OSCP-Specific Scan Strategies

### Initial Recon Scan
```bash
nmap -sS -p- --min-rate 1000 --max-retries 1 <target> -oN initial_scan.txt
```

### Detailed Service Scan
```bash
nmap -sV -sC -p <open_ports_from_initial_scan> <target> -oN detailed_scan.txt
```

### UDP Top Ports Scan
```bash
nmap -sU --top-ports 20 <target> -oN udp_scan.txt
```

### Vulnerability Scan (For Lab Practice Only)
```bash
nmap --script=vuln -p <open_ports> <target> -oN vuln_scan.txt
```

### All-in-One Aggressive Scan
```bash
nmap -sS -sV -sC -O -p- <target> -oA full_scan
```

## Practical Tips for OSCP

1. **Always start with a quick scan** to identify live hosts and common ports
2. **Follow up with a full port scan** to ensure you don't miss any services
3. **Run detailed scans only on open ports** to save time
4. **Save all scan results** for documentation and reference
5. **Use NSE scripts selectively** to avoid detection and save time
6. **Scan both TCP and UDP** ports as services might be running on either
7. **Adjust timing based on network conditions** - faster isn't always better
8. **Remember that Nmap isn't perfect** - manually verify findings when possible
9. **Combine Nmap with other tools** for comprehensive enumeration
10. **Document your methodology** for the OSCP report

## Common Ports and Services to Focus On

| Port | Service | Notes |
|------|---------|-------|
| 21 | FTP | Check for anonymous login, outdated versions |
| 22 | SSH | Check for outdated versions, weak ciphers |
| 23 | Telnet | Often has weak security |
| 25 | SMTP | Email server, check for open relay |
| 53 | DNS | Zone transfers, outdated versions |
| 80/443 | HTTP/HTTPS | Web applications, directories, default credentials |
| 110/995 | POP3/POP3S | Email retrieval |
| 111 | RPC | Often leads to NFS |
| 135 | MSRPC | Windows RPC service |
| 139/445 | SMB/CIFS | File shares, null sessions, EternalBlue |
| 161/162 | SNMP | Community strings, information disclosure |
| 1433 | MSSQL | Database, default credentials |
| 2049 | NFS | Mountable shares, file access |
| 3306 | MySQL | Database, default credentials |
| 3389 | RDP | Remote Desktop, BlueKeep |
| 5432 | PostgreSQL | Database, default credentials |
| 5900 | VNC | Remote desktop without authentication |
| 6379 | Redis | NoSQL database, often unsecured |
| 8080/8443 | HTTP/HTTPS Alt | Web applications, admin interfaces |
