#!/bin/bash
# Kali Linux Configuration Script for OSCP
# This script automates the setup of a Kali Linux environment optimized for OSCP

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${YELLOW}[*]${NC} $1"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[-]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    exit 1
fi

# Create OSCP directory structure
create_directory_structure() {
    print_status "Creating OSCP directory structure..."
    
    mkdir -p ~/oscp/{tools,exploits,wordlists,loot,scans,reports,targets,scripts,screenshots}
    
    # Create README files in each directory
    echo "# Tools Directory" > ~/oscp/tools/README.md
    echo "Store custom tools and scripts here." >> ~/oscp/tools/README.md
    
    echo "# Exploits Directory" > ~/oscp/exploits/README.md
    echo "Store custom exploits and exploit modifications here." >> ~/oscp/exploits/README.md
    
    echo "# Wordlists Directory" > ~/oscp/wordlists/README.md
    echo "Store custom wordlists here." >> ~/oscp/wordlists/README.md
    
    echo "# Loot Directory" > ~/oscp/loot/README.md
    echo "Store credentials, hashes, and other sensitive data here." >> ~/oscp/loot/README.md
    
    echo "# Scans Directory" > ~/oscp/scans/README.md
    echo "Store scan results here." >> ~/oscp/scans/README.md
    
    echo "# Reports Directory" > ~/oscp/reports/README.md
    echo "Store documentation and reports here." >> ~/oscp/reports/README.md
    
    echo "# Targets Directory" > ~/oscp/targets/README.md
    echo "Create a subdirectory for each target machine." >> ~/oscp/targets/README.md
    
    echo "# Scripts Directory" > ~/oscp/scripts/README.md
    echo "Store custom scripts here." >> ~/oscp/scripts/README.md
    
    echo "# Screenshots Directory" > ~/oscp/screenshots/README.md
    echo "Store screenshots for documentation here." >> ~/oscp/screenshots/README.md
    
    print_success "Directory structure created at ~/oscp/"
}

# Update and upgrade system
update_system() {
    print_status "Updating system packages..."
    apt update
    apt upgrade -y
    apt autoremove -y
    apt autoclean
    print_success "System updated"
}

# Install additional tools
install_tools() {
    print_status "Installing additional tools..."
    
    # Common tools
    apt install -y \
        tmux \
        vim \
        python3-pip \
        python3-venv \
        seclists \
        curl \
        wget \
        git \
        net-tools \
        dnsutils \
        whois \
        netcat-traditional \
        proxychains4 \
        exiftool \
        steghide \
        binwalk \
        foremost \
        ffuf \
        feroxbuster \
        wpscan \
        crackmapexec \
        bloodhound \
        neo4j \
        smbclient \
        enum4linux \
        nbtscan \
        onesixtyone \
        oscanner \
        whatweb \
        wafw00f \
        sqlmap \
        responder \
        hashcat \
        hashid \
        fcrackzip \
        john \
        hydra \
        wordlists \
        flameshot
    
    # Python packages
    pip3 install impacket pycryptodome pyftpdlib
    
    print_success "Additional tools installed"
}

# Configure shell environment
configure_shell() {
    print_status "Configuring shell environment..."
    
    # Check if using bash or zsh
    if [ -f ~/.zshrc ]; then
        SHELL_RC=~/.zshrc
    else
        SHELL_RC=~/.bashrc
    fi
    
    # Add aliases
    cat << 'EOF' >> $SHELL_RC

# OSCP aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias nse='ls /usr/share/nmap/scripts | grep'
alias webserver='python3 -m http.server 8000'
alias smb-server='sudo impacket-smbserver share $(pwd) -smb2support'
alias scan='sudo nmap -sC -sV -oA'
alias portscan='sudo nmap -p-'
alias vulnscan='sudo nmap --script vuln'
alias dirb='gobuster dir -u'
alias dirbig='gobuster dir -u $1 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt,html'
alias hashid='hashid -m'
alias screenshot='scrot -s ~/oscp/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'

# Function to create a new target directory
function newtarget() {
  mkdir -p ~/oscp/targets/$1/{scans,exploits,loot,notes}
  echo "# Target: $1" > ~/oscp/targets/$1/notes/initial.md
  echo "Created target directory for $1"
}

# Function to extract nmap information
function extractports() {
  ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
  ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
  echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
  echo -e "\t[*] IP Address: $ip_address" >> extractPorts.tmp
  echo -e "\t[*] Open ports: $ports\n" >> extractPorts.tmp
  echo $ports | tr -d '\n' | xclip -sel clip
  echo -e "[*] Ports copied to clipboard\n" >> extractPorts.tmp
  cat extractPorts.tmp
  rm extractPorts.tmp
}
EOF
    
    # Configure tmux
    cat << 'EOF' > ~/.tmux.conf
# Enable mouse mode
set -g mouse on

# Set prefix to Ctrl-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable vi mode
setw -g mode-keys vi

# Status bar customization
set -g status-bg black
set -g status-fg white
set -g status-left-length 30
set -g status-left '#[fg=green](#S) #(whoami) '
set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=white]%H:%M#[default]'
EOF
    
    print_success "Shell environment configured"
}

# Clone useful GitHub repositories
clone_repositories() {
    print_status "Cloning useful GitHub repositories..."
    
    cd ~/oscp/tools
    
    # PEASS - Privilege Escalation Scripts
    git clone https://github.com/carlospolop/PEASS-ng.git
    
    # PayloadsAllTheThings
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
    
    # SecLists (if not installed via apt)
    if [ ! -d "/usr/share/seclists" ]; then
        git clone https://github.com/danielmiessler/SecLists.git
    fi
    
    # Windows Privilege Escalation
    git clone https://github.com/pentestmonkey/windows-privesc-check.git
    
    # Linux Privilege Escalation
    git clone https://github.com/rebootuser/LinEnum.git
    git clone https://github.com/mzet-/linux-exploit-suggester.git
    
    # PowerShell tools
    git clone https://github.com/PowerShellMafia/PowerSploit.git
    git clone https://github.com/samratashok/nishang.git
    
    print_success "Repositories cloned to ~/oscp/tools/"
}

# Configure Firefox for penetration testing
configure_firefox() {
    print_status "Firefox configuration must be done manually. Please install these add-ons:"
    echo "1. FoxyProxy"
    echo "2. Wappalyzer"
    echo "3. Cookie-Editor"
    echo "4. User-Agent Switcher"
    
    print_status "Also configure these Firefox settings:"
    echo "1. about:config -> security.fileuri.strict_origin_policy = false"
    echo "2. about:config -> network.proxy.type = 0"
}

# Main function
main() {
    print_status "Starting Kali Linux configuration for OSCP..."
    
    update_system
    install_tools
    create_directory_structure
    configure_shell
    clone_repositories
    configure_firefox
    
    print_success "Configuration complete!"
    print_status "Please restart your terminal or source your shell configuration file."
    print_status "Run 'source ~/.zshrc' or 'source ~/.bashrc' to apply changes immediately."
}

# Run the main function
main
