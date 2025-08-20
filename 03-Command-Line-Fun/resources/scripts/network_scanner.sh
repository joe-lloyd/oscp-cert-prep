#!/bin/bash
# Network Scanner Script for OSCP
# This script provides various network scanning techniques using command line tools

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_color "$RED" "This scan requires root privileges. Please run with sudo."
        return 1
    fi
    return 0
}

# Function to validate IP address
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a ip_array <<< "$ip"
        for octet in "${ip_array[@]}"; do
            if [[ $octet -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Function to validate network range
validate_network() {
    local network=$1
    if [[ $network =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]; then
        local ip=$(echo $network | cut -d'/' -f1)
        local cidr=$(echo $network | cut -d'/' -f2)
        if ! validate_ip "$ip"; then
            return 1
        fi
        if [[ $cidr -lt 0 || $cidr -gt 32 ]]; then
            return 1
        fi
        return 0
    else
        return 1
    fi
}

# Function to perform a ping sweep
ping_sweep() {
    clear
    print_color "$BLUE" "===== PING SWEEP ====="
    
    read -p "Enter target network (e.g., 192.168.1.0/24): " network
    
    if ! validate_network "$network"; then
        print_color "$RED" "Invalid network format. Please use CIDR notation (e.g., 192.168.1.0/24)."
        return
    fi
    
    # Extract base network
    base_network=$(echo $network | cut -d'/' -f1 | cut -d'.' -f1-3)
    
    print_color "$YELLOW" "Performing ping sweep on $network..."
    print_color "$YELLOW" "This may take a while depending on the network size..."
    
    # Create results directory if it doesn't exist
    mkdir -p ~/network_scan_results
    output_file=~/network_scan_results/ping_sweep_$(date +%Y%m%d_%H%M%S).txt
    
    echo "Ping Sweep Results for $network" > $output_file
    echo "Scan started at $(date)" >> $output_file
    echo "----------------------------------------" >> $output_file
    
    # Method selection
    echo "Select ping sweep method:"
    echo "1. fping (fastest, if available)"
    echo "2. nmap (requires nmap)"
    echo "3. Pure bash (slowest but works everywhere)"
    read -p "Enter your choice (1-3): " method_choice
    
    case $method_choice in
        1)
            if command_exists fping; then
                print_color "$YELLOW" "Using fping for ping sweep..."
                fping -a -g $network 2>/dev/null | tee -a $output_file
            else
                print_color "$RED" "fping not found. Please install it or choose another method."
                return
            fi
            ;;
        2)
            if command_exists nmap; then
                print_color "$YELLOW" "Using nmap for ping sweep..."
                nmap -sn $network | grep "Nmap scan report" | tee -a $output_file
            else
                print_color "$RED" "nmap not found. Please install it or choose another method."
                return
            fi
            ;;
        3)
            print_color "$YELLOW" "Using bash for ping sweep (this may be slow)..."
            for i in $(seq 1 254); do
                (ping -c 1 -W 1 $base_network.$i | grep "bytes from" | cut -d" " -f4 | cut -d":" -f1 | tee -a $output_file) &
                # Run 10 pings in parallel
                [[ $(( i % 10 )) -eq 0 ]] && wait
            done
            wait
            ;;
        *)
            print_color "$RED" "Invalid choice."
            return
            ;;
    esac
    
    echo "----------------------------------------" >> $output_file
    echo "Scan completed at $(date)" >> $output_file
    
    print_color "$GREEN" "Ping sweep completed. Results saved to $output_file"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to perform a port scan
port_scan() {
    clear
    print_color "$BLUE" "===== PORT SCAN ====="
    
    read -p "Enter target IP or hostname: " target
    
    # Create results directory if it doesn't exist
    mkdir -p ~/network_scan_results
    output_file=~/network_scan_results/port_scan_$(date +%Y%m%d_%H%M%S).txt
    
    echo "Port Scan Results for $target" > $output_file
    echo "Scan started at $(date)" >> $output_file
    echo "----------------------------------------" >> $output_file
    
    # Method selection
    echo "Select port scan method:"
    echo "1. nmap (recommended, if available)"
    echo "2. nc (netcat)"
    echo "3. Pure bash (slow but works everywhere)"
    read -p "Enter your choice (1-3): " method_choice
    
    case $method_choice in
        1)
            if command_exists nmap; then
                echo "Select scan type:"
                echo "1. Quick scan (top ports)"
                echo "2. Full scan (all ports)"
                echo "3. Service detection"
                echo "4. OS detection (requires root)"
                echo "5. Comprehensive scan (requires root)"
                read -p "Enter your choice (1-5): " scan_type
                
                case $scan_type in
                    1)
                        print_color "$YELLOW" "Performing quick scan..."
                        nmap -F $target | tee -a $output_file
                        ;;
                    2)
                        print_color "$YELLOW" "Performing full scan (this may take a while)..."
                        nmap -p- $target | tee -a $output_file
                        ;;
                    3)
                        print_color "$YELLOW" "Performing service detection scan..."
                        nmap -sV $target | tee -a $output_file
                        ;;
                    4)
                        if check_root; then
                            print_color "$YELLOW" "Performing OS detection scan..."
                            nmap -O $target | tee -a $output_file
                        fi
                        ;;
                    5)
                        if check_root; then
                            print_color "$YELLOW" "Performing comprehensive scan (this may take a while)..."
                            nmap -sS -sV -sC -A -O $target | tee -a $output_file
                        fi
                        ;;
                    *)
                        print_color "$RED" "Invalid choice."
                        return
                        ;;
                esac
            else
                print_color "$RED" "nmap not found. Please install it or choose another method."
                return
            fi
            ;;
        2)
            if command_exists nc; then
                print_color "$YELLOW" "Using netcat for port scan..."
                read -p "Enter port range (e.g., 1-1000): " port_range
                
                start_port=$(echo $port_range | cut -d'-' -f1)
                end_port=$(echo $port_range | cut -d'-' -f2)
                
                for port in $(seq $start_port $end_port); do
                    (nc -z -v -w1 $target $port 2>&1 | grep "open" | tee -a $output_file) &
                    # Run 10 scans in parallel
                    [[ $(( (port - start_port + 1) % 10 )) -eq 0 ]] && wait
                done
                wait
            else
                print_color "$RED" "netcat not found. Please install it or choose another method."
                return
            fi
            ;;
        3)
            print_color "$YELLOW" "Using bash for port scan (this may be slow)..."
            read -p "Enter port range (e.g., 1-1000): " port_range
            
            start_port=$(echo $port_range | cut -d'-' -f1)
            end_port=$(echo $port_range | cut -d'-' -f2)
            
            for port in $(seq $start_port $end_port); do
                (timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null && echo "Port $port is open" | tee -a $output_file) &
                # Run 10 scans in parallel
                [[ $(( (port - start_port + 1) % 10 )) -eq 0 ]] && wait
            done
            wait
            ;;
        *)
            print_color "$RED" "Invalid choice."
            return
            ;;
    esac
    
    echo "----------------------------------------" >> $output_file
    echo "Scan completed at $(date)" >> $output_file
    
    print_color "$GREEN" "Port scan completed. Results saved to $output_file"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to perform banner grabbing
banner_grabbing() {
    clear
    print_color "$BLUE" "===== BANNER GRABBING ====="
    
    read -p "Enter target IP or hostname: " target
    read -p "Enter port: " port
    
    # Create results directory if it doesn't exist
    mkdir -p ~/network_scan_results
    output_file=~/network_scan_results/banner_grab_$(date +%Y%m%d_%H%M%S).txt
    
    echo "Banner Grabbing Results for $target:$port" > $output_file
    echo "Scan started at $(date)" >> $output_file
    echo "----------------------------------------" >> $output_file
    
    # Method selection
    echo "Select banner grabbing method:"
    echo "1. netcat (nc)"
    echo "2. telnet"
    echo "3. curl (for HTTP/HTTPS)"
    echo "4. openssl (for SSL/TLS services)"
    read -p "Enter your choice (1-4): " method_choice
    
    case $method_choice in
        1)
            if command_exists nc; then
                print_color "$YELLOW" "Using netcat for banner grabbing..."
                print_color "$YELLOW" "Press Ctrl+C to exit after receiving the banner."
                echo "" | nc -v -n -w 3 $target $port 2>&1 | tee -a $output_file
            else
                print_color "$RED" "netcat not found. Please install it or choose another method."
                return
            fi
            ;;
        2)
            if command_exists telnet; then
                print_color "$YELLOW" "Using telnet for banner grabbing..."
                print_color "$YELLOW" "Press Ctrl+] and then 'q' to exit after receiving the banner."
                echo "Trying to connect to $target:$port..." | tee -a $output_file
                telnet $target $port | tee -a $output_file
            else
                print_color "$RED" "telnet not found. Please install it or choose another method."
                return
            fi
            ;;
        3)
            if command_exists curl; then
                print_color "$YELLOW" "Using curl for HTTP/HTTPS banner grabbing..."
                echo "HTTP Headers:" | tee -a $output_file
                curl -I $target:$port 2>/dev/null | tee -a $output_file
                echo "" | tee -a $output_file
                echo "Server Response:" | tee -a $output_file
                curl -s $target:$port | head -20 | tee -a $output_file
            else
                print_color "$RED" "curl not found. Please install it or choose another method."
                return
            fi
            ;;
        4)
            if command_exists openssl; then
                print_color "$YELLOW" "Using openssl for SSL/TLS banner grabbing..."
                echo "Q" | openssl s_client -connect $target:$port 2>/dev/null | tee -a $output_file
            else
                print_color "$RED" "openssl not found. Please install it or choose another method."
                return
            fi
            ;;
        *)
            print_color "$RED" "Invalid choice."
            return
            ;;
    esac
    
    echo "----------------------------------------" >> $output_file
    echo "Banner grabbing completed at $(date)" >> $output_file
    
    print_color "$GREEN" "Banner grabbing completed. Results saved to $output_file"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to perform DNS enumeration
dns_enumeration() {
    clear
    print_color "$BLUE" "===== DNS ENUMERATION ====="
    
    read -p "Enter target domain: " domain
    
    # Create results directory if it doesn't exist
    mkdir -p ~/network_scan_results
    output_file=~/network_scan_results/dns_enum_$(date +%Y%m%d_%H%M%S).txt
    
    echo "DNS Enumeration Results for $domain" > $output_file
    echo "Scan started at $(date)" >> $output_file
    echo "----------------------------------------" >> $output_file
    
    # Check for required tools
    if ! command_exists host && ! command_exists dig && ! command_exists nslookup; then
        print_color "$RED" "No DNS tools found. Please install host, dig, or nslookup."
        return
    fi
    
    # Method selection
    echo "Select DNS enumeration method:"
    echo "1. Basic DNS queries"
    echo "2. Zone transfer attempt"
    echo "3. Subdomain bruteforce"
    echo "4. All of the above"
    read -p "Enter your choice (1-4): " method_choice
    
    case $method_choice in
        1|4)
            print_color "$YELLOW" "Performing basic DNS queries..."
            
            echo "=== A Records ===" | tee -a $output_file
            if command_exists host; then
                host -t A $domain | tee -a $output_file
            elif command_exists dig; then
                dig A $domain | tee -a $output_file
            else
                nslookup -type=A $domain | tee -a $output_file
            fi
            
            echo "" | tee -a $output_file
            echo "=== MX Records ===" | tee -a $output_file
            if command_exists host; then
                host -t MX $domain | tee -a $output_file
            elif command_exists dig; then
                dig MX $domain | tee -a $output_file
            else
                nslookup -type=MX $domain | tee -a $output_file
            fi
            
            echo "" | tee -a $output_file
            echo "=== NS Records ===" | tee -a $output_file
            if command_exists host; then
                host -t NS $domain | tee -a $output_file
            elif command_exists dig; then
                dig NS $domain | tee -a $output_file
            else
                nslookup -type=NS $domain | tee -a $output_file
            fi
            
            echo "" | tee -a $output_file
            echo "=== TXT Records ===" | tee -a $output_file
            if command_exists host; then
                host -t TXT $domain | tee -a $output_file
            elif command_exists dig; then
                dig TXT $domain | tee -a $output_file
            else
                nslookup -type=TXT $domain | tee -a $output_file
            fi
            
            if [[ $method_choice -eq 1 ]]; then
                echo "----------------------------------------" >> $output_file
                echo "DNS enumeration completed at $(date)" >> $output_file
                print_color "$GREEN" "Basic DNS queries completed. Results saved to $output_file"
                print_color "$YELLOW" "Press Enter to continue..."
                read
                return
            fi
            ;;
    esac
    
    case $method_choice in
        2|4)
            print_color "$YELLOW" "Attempting zone transfer..."
            echo "" | tee -a $output_file
            echo "=== Zone Transfer Attempt ===" | tee -a $output_file
            
            # Get name servers first
            if command_exists host; then
                nameservers=$(host -t NS $domain | grep "name server" | awk '{print $4}')
            elif command_exists dig; then
                nameservers=$(dig NS $domain | grep -A1 "ANSWER SECTION" | grep -v "ANSWER SECTION" | awk '{print $5}')
            else
                nameservers=$(nslookup -type=NS $domain | grep "nameserver" | awk '{print $4}')
            fi
            
            # Try zone transfer with each name server
            for ns in $nameservers; do
                echo "Attempting zone transfer from $ns..." | tee -a $output_file
                if command_exists host; then
                    host -l $domain $ns | tee -a $output_file
                elif command_exists dig; then
                    dig @$ns $domain AXFR | tee -a $output_file
                else
                    nslookup -type=AXFR $domain $ns | tee -a $output_file
                fi
            done
            
            if [[ $method_choice -eq 2 ]]; then
                echo "----------------------------------------" >> $output_file
                echo "Zone transfer attempts completed at $(date)" >> $output_file
                print_color "$GREEN" "Zone transfer attempts completed. Results saved to $output_file"
                print_color "$YELLOW" "Press Enter to continue..."
                read
                return
            fi
            ;;
    esac
    
    case $method_choice in
        3|4)
            print_color "$YELLOW" "Performing subdomain bruteforce..."
            echo "" | tee -a $output_file
            echo "=== Subdomain Bruteforce ===" | tee -a $output_file
            
            # Create a small wordlist if none is provided
            wordlist="/tmp/subdomain_wordlist.txt"
            echo "Creating a basic subdomain wordlist..."
            cat > $wordlist << EOF
www
mail
remote
blog
webmail
server
ns1
ns2
smtp
secure
vpn
m
shop
ftp
api
dev
staging
test
admin
portal
intranet
EOF
            
            echo "Using wordlist with $(wc -l < $wordlist) entries" | tee -a $output_file
            
            for sub in $(cat $wordlist); do
                if command_exists host; then
                    host $sub.$domain | grep "has address" | tee -a $output_file
                elif command_exists dig; then
                    dig +short $sub.$domain A | grep -v "^$" | sed "s/^/$sub.$domain: /" | tee -a $output_file
                else
                    nslookup $sub.$domain | grep "Address:" | grep -v "#" | sed "s/Address: /$sub.$domain: /" | tee -a $output_file
                fi
            done
            
            # Clean up
            rm $wordlist
            ;;
    esac
    
    echo "----------------------------------------" >> $output_file
    echo "DNS enumeration completed at $(date)" >> $output_file
    
    print_color "$GREEN" "DNS enumeration completed. Results saved to $output_file"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to perform network mapping
network_mapping() {
    clear
    print_color "$BLUE" "===== NETWORK MAPPING ====="
    
    read -p "Enter target network (e.g., 192.168.1.0/24): " network
    
    if ! validate_network "$network"; then
        print_color "$RED" "Invalid network format. Please use CIDR notation (e.g., 192.168.1.0/24)."
        return
    fi
    
    # Create results directory if it doesn't exist
    mkdir -p ~/network_scan_results
    output_file=~/network_scan_results/network_map_$(date +%Y%m%d_%H%M%S).txt
    
    echo "Network Mapping Results for $network" > $output_file
    echo "Scan started at $(date)" >> $output_file
    echo "----------------------------------------" >> $output_file
    
    # Check if we have the required tools
    if ! command_exists nmap; then
        print_color "$RED" "nmap not found. Network mapping requires nmap."
        return
    fi
    
    # Method selection
    echo "Select network mapping method:"
    echo "1. Basic host discovery"
    echo "2. Host discovery with port scanning"
    echo "3. Comprehensive network mapping (requires root)"
    read -p "Enter your choice (1-3): " method_choice
    
    case $method_choice in
        1)
            print_color "$YELLOW" "Performing basic host discovery..."
            nmap -sn $network | tee -a $output_file
            ;;
        2)
            print_color "$YELLOW" "Performing host discovery with port scanning..."
            nmap -sS -F $network | tee -a $output_file
            ;;
        3)
            if check_root; then
                print_color "$YELLOW" "Performing comprehensive network mapping (this may take a while)..."
                nmap -sS -sV -O --osscan-guess $network | tee -a $output_file
            fi
            ;;
        *)
            print_color "$RED" "Invalid choice."
            return
            ;;
    esac
    
    echo "----------------------------------------" >> $output_file
    echo "Network mapping completed at $(date)" >> $output_file
    
    print_color "$GREEN" "Network mapping completed. Results saved to $output_file"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Main menu
main_menu() {
    while true; do
        clear
        print_color "$BLUE" "===== NETWORK SCANNER TOOL ====="
        print_color "$YELLOW" "Select an option:"
        echo "1. Ping Sweep"
        echo "2. Port Scan"
        echo "3. Banner Grabbing"
        echo "4. DNS Enumeration"
        echo "5. Network Mapping"
        echo "6. Exit"
        
        read -p "Enter your choice (1-6): " choice
        
        case $choice in
            1) ping_sweep ;;
            2) port_scan ;;
            3) banner_grabbing ;;
            4) dns_enumeration ;;
            5) network_mapping ;;
            6) 
                print_color "$GREEN" "Thank you for using the Network Scanner Tool!"
                exit 0
                ;;
            *)
                print_color "$RED" "Invalid option. Press Enter to continue."
                read
                ;;
        esac
    done
}

# Start the script
print_color "$GREEN" "Welcome to the Network Scanner Tool!"
print_color "$YELLOW" "This tool will help you practice network scanning techniques for OSCP."
print_color "$RED" "IMPORTANT: Only use this tool on networks you have permission to scan."
echo
print_color "$YELLOW" "Press Enter to continue..."
read
main_menu
