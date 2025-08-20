# Setting Up a Kali Linux VM for OSCP

This guide provides step-by-step instructions for setting up a Kali Linux virtual machine optimized for OSCP exam preparation.

## VMware Setup (Recommended for OSCP)

### Step 1: Download Required Files

1. Download the latest Kali Linux VMware image:
   - Visit [https://www.kali.org/get-kali/#kali-virtual-machines](https://www.kali.org/get-kali/#kali-virtual-machines)
   - Download the VMware image (e.g., `kali-linux-2023.2-vmware-amd64.7z`)

2. Download and install VMware:
   - VMware Workstation Pro (Windows/Linux): [https://www.vmware.com/products/workstation-pro.html](https://www.vmware.com/products/workstation-pro.html)
   - VMware Fusion (macOS): [https://www.vmware.com/products/fusion.html](https://www.vmware.com/products/fusion.html)

### Step 2: Import the Kali VM

1. Extract the downloaded Kali Linux VMware image
2. Open VMware Workstation/Fusion
3. Select "Open a Virtual Machine"
4. Navigate to the extracted folder and select the `.vmx` file
5. Click "Import"

### Step 3: Configure VM Settings

For optimal OSCP performance, adjust these settings:

1. Right-click the VM and select "Settings"
2. Memory: Allocate at least 4GB RAM (8GB recommended)
3. Processors: Assign at least 2 cores
4. Hard Disk: Expand to at least 80GB
5. Network Adapter: Set to NAT

## VirtualBox Setup (Alternative)

### Step 1: Download Required Files

1. Download the Kali Linux VirtualBox image:
   - Visit [https://www.kali.org/get-kali/#kali-virtual-machines](https://www.kali.org/get-kali/#kali-virtual-machines)
   - Download the VirtualBox image (e.g., `kali-linux-2023.2-virtualbox-amd64.7z`)

2. Download and install VirtualBox:
   - Visit [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

### Step 2: Import the Kali VM

1. Extract the downloaded Kali Linux VirtualBox image
2. Open VirtualBox
3. Click "File" → "Import Appliance"
4. Navigate to the extracted folder and select the `.ova` file
5. Click "Next" and then "Import"

### Step 3: Configure VM Settings

1. Right-click the VM and select "Settings"
2. System → Motherboard: Allocate at least 4GB RAM
3. System → Processor: Assign at least 2 cores
4. Display → Screen: Enable 3D Acceleration
5. Network: Set to NAT

## Post-Installation Configuration

After setting up your VM, perform these essential configurations:

### 1. Update the System

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean
```

### 2. Install VM Tools

For VMware:
```bash
sudo apt install -y open-vm-tools-desktop
sudo reboot
```

For VirtualBox:
```bash
sudo apt install -y virtualbox-guest-x11
sudo reboot
```

### 3. Create Snapshot

Create a clean snapshot after the initial setup:

- VMware: VM → Snapshot → Take Snapshot
- VirtualBox: VM → Snapshots → Take Snapshot

### 4. Configure Shared Folders (Optional)

For VMware:
```bash
# Create mount point
mkdir ~/shared

# Edit fstab to auto-mount
echo ".host:/shared  /home/kali/shared  fuse.vmhgfs-fuse  defaults,allow_other  0  0" | sudo tee -a /etc/fstab

# Mount all
sudo mount -a
```

For VirtualBox:
```bash
# Add user to vboxsf group
sudo usermod -aG vboxsf kali

# Create mount point
mkdir ~/shared

# Mount shared folder
sudo mount -t vboxsf shared ~/shared
```

## OSCP-Specific Optimizations

### 1. Install Additional Tools

```bash
# Install common tools used in OSCP
sudo apt install -y gobuster seclists feroxbuster wpscan crackmapexec bloodhound neo4j

# Install Python tools
sudo pip3 install impacket pypykatz
```

### 2. Configure Firefox for Web Testing

1. Install useful extensions:
   - FoxyProxy
   - Wappalyzer
   - Cookie-Editor

2. Configure Firefox settings:
   - Type `about:config` in the address bar
   - Set `security.fileuri.strict_origin_policy` to `false`
   - Set `network.proxy.type` to `0`

### 3. Set Up Directory Structure

```bash
# Create organized directory structure
mkdir -p ~/oscp/{scans,exploits,tools,loot,reports,screenshots}

# Create a README file
echo "# OSCP Directory Structure" > ~/oscp/README.md
echo "- scans: Nmap and vulnerability scans" >> ~/oscp/README.md
echo "- exploits: Custom and modified exploits" >> ~/oscp/README.md
echo "- tools: Custom scripts and tools" >> ~/oscp/README.md
echo "- loot: Credentials and sensitive data" >> ~/oscp/README.md
echo "- reports: Documentation and reports" >> ~/oscp/README.md
echo "- screenshots: Evidence for the report" >> ~/oscp/README.md
```

### 4. Configure Aliases

Add these useful aliases to your `.zshrc` or `.bashrc`:

```bash
# Add to ~/.zshrc
cat << 'EOF' >> ~/.zshrc

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
EOF

# Reload shell configuration
source ~/.zshrc
```

## Troubleshooting Common VM Issues

### Network Issues

If you can't connect to the internet:

1. Check VM network settings:
   ```bash
   ip a
   ```

2. Restart network service:
   ```bash
   sudo systemctl restart NetworkManager
   ```

3. Verify DNS configuration:
   ```bash
   cat /etc/resolv.conf
   ```

### Display Issues

If you experience display problems:

1. Update graphics drivers:
   ```bash
   sudo apt install -y firmware-linux
   ```

2. Reconfigure display settings:
   ```bash
   sudo dpkg-reconfigure xserver-xorg
   ```

### Performance Issues

If the VM is running slowly:

1. Close unnecessary applications
2. Increase VM resources (RAM, CPU)
3. Disable visual effects:
   ```bash
   xfconf-query -c xfwm4 -p /general/use_compositing -s false
   ```

## Final Checklist

Before starting your OSCP journey, verify:

- [x] VM has adequate resources (RAM, CPU, disk space)
- [x] System is fully updated
- [x] VM tools are installed
- [x] Clean snapshot is created
- [x] Directory structure is set up
- [x] Essential tools are installed
- [x] Browser is configured for web testing
- [x] Useful aliases are configured
- [x] Network connectivity is working
