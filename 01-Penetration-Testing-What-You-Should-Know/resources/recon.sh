#!/bin/bash
# Basic Reconnaissance Script for OSCP Practice
# Usage: ./recon.sh <target_ip_or_domain>

if [ -z "$1" ]; then
    echo "Usage: $0 <target_ip_or_domain>"
    exit 1
fi

TARGET=$1
OUTPUT_DIR="recon_$(echo $TARGET | tr '.' '_')"

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo "[+] Created output directory: $OUTPUT_DIR"

# Banner
echo "=================================================="
echo "    OSCP Reconnaissance Script"
echo "    Target: $TARGET"
echo "    Date: $(date)"
echo "=================================================="

# Check if target is IP or domain
if [[ $TARGET =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    IS_IP=true
    echo "[+] Target is an IP address"
else
    IS_IP=false
    echo "[+] Target is a domain name"
fi

# Phase 1: Passive Reconnaissance (if domain)
if [ "$IS_IP" = false ]; then
    echo -e "\n[+] Phase 1: Passive Reconnaissance"
    echo "[*] Performing WHOIS lookup..."
    whois "$TARGET" > "$OUTPUT_DIR/whois.txt"
    echo "    - WHOIS data saved to $OUTPUT_DIR/whois.txt"
    
    echo "[*] Performing DNS lookups..."
    host "$TARGET" > "$OUTPUT_DIR/host.txt"
    dig "$TARGET" ANY +noall +answer >> "$OUTPUT_DIR/host.txt"
    dig -x "$TARGET" +noall +answer >> "$OUTPUT_DIR/host.txt"
    echo "    - DNS data saved to $OUTPUT_DIR/host.txt"
    
    # Get IP for further scanning
    TARGET_IP=$(dig +short "$TARGET" | head -n 1)
    if [ -n "$TARGET_IP" ]; then
        echo "[*] Resolved IP: $TARGET_IP"
    else
        echo "[!] Could not resolve IP address for $TARGET"
        TARGET_IP=$TARGET
    fi
else
    TARGET_IP=$TARGET
fi

# Phase 2: Active Reconnaissance
echo -e "\n[+] Phase 2: Active Reconnaissance"

# Basic port scan
echo "[*] Performing quick port scan (top 1000 ports)..."
nmap -sV -sC -oA "$OUTPUT_DIR/nmap_quick" "$TARGET_IP"
echo "    - Quick scan results saved to $OUTPUT_DIR/nmap_quick.nmap"

# Full port scan in background
echo "[*] Starting full port scan in background..."
nmap -p- -sV --reason --open -oA "$OUTPUT_DIR/nmap_full" "$TARGET_IP" > /dev/null 2>&1 &
NMAP_PID=$!
echo "    - Full scan running with PID $NMAP_PID"
echo "    - Results will be saved to $OUTPUT_DIR/nmap_full.nmap"

# Check for common web ports
echo "[*] Checking for web services..."
for port in 80 443 8080 8443; do
    timeout 2 bash -c "echo > /dev/tcp/$TARGET_IP/$port" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "    - Web service found on port $port"
        echo "http://$TARGET_IP:$port" >> "$OUTPUT_DIR/web_services.txt"
    fi
done

# Summary
echo -e "\n[+] Reconnaissance Summary:"
echo "    - Target: $TARGET"
echo "    - Output directory: $OUTPUT_DIR"
echo "    - Quick scan completed"
echo "    - Full scan running in background (PID: $NMAP_PID)"
if [ -f "$OUTPUT_DIR/web_services.txt" ]; then
    echo "    - Web services found:"
    cat "$OUTPUT_DIR/web_services.txt" | sed 's/^/      /'
fi

echo -e "\n[+] Next Steps:"
echo "    1. Review the scan results"
echo "    2. Identify potential vulnerabilities"
echo "    3. Plan your exploitation strategy"
echo "    4. Document your findings"

echo -e "\n[+] Remember: Try Harder!"
