# Kali Linux Practical Exercises

These exercises will help you become proficient with Kali Linux and prepare you for the OSCP exam. Complete them to build a solid foundation in using the operating system and its tools.

## Exercise 1: Kali Linux Installation and Configuration

**Objective:** Set up a fully functional Kali Linux environment optimized for penetration testing.

**Tasks:**
1. Install Kali Linux using one of the following methods:
   - As a virtual machine (recommended)
   - Dual boot
   - Live USB with persistence
   
2. Perform initial configuration:
   - Update the system
   - Install VM tools (if using a VM)
   - Configure networking
   
3. Create an organized directory structure:
   ```
   ~/oscp/
   ├── tools/
   ├── targets/
   ├── exploits/
   ├── scripts/
   ├── wordlists/
   ├── loot/
   └── reports/
   ```

4. Configure your terminal environment:
   - Set up useful aliases in `.zshrc` or `.bashrc`
   - Configure tab completion
   - Set up command history preferences

**Deliverable:** Screenshot of your configured Kali Linux desktop and terminal showing the directory structure and aliases.

## Exercise 2: Tool Inventory and Familiarization

**Objective:** Become familiar with the location and basic usage of essential penetration testing tools in Kali Linux.

**Tasks:**
1. Create an inventory of tools for each phase of penetration testing:
   - Information gathering
   - Vulnerability scanning
   - Exploitation
   - Post-exploitation
   - Privilege escalation
   - Documentation

2. For each tool category, document:
   - Tool name
   - Location in Kali menu
   - Command to launch from terminal
   - Basic usage example
   - Common flags/options

3. Verify each tool is installed and working:
   ```bash
   which <tool_name>
   <tool_name> --help
   ```

4. Install any missing tools you think will be useful for OSCP.

**Deliverable:** A markdown document with your tool inventory, including examples of basic usage for each tool.

## Exercise 3: Network Configuration and Troubleshooting

**Objective:** Learn to configure and troubleshoot network settings in Kali Linux.

**Tasks:**
1. Configure your network interfaces:
   - Identify all network interfaces
   - Configure a static IP address
   - Configure a dynamic IP address
   - Set up a virtual interface

2. Troubleshoot common network issues:
   - Reset NetworkManager
   - Check DNS configuration
   - Verify routing table
   - Test connectivity

3. Set up a VPN connection:
   - Install OpenVPN
   - Configure a VPN connection
   - Test connection and verify IP change
   - Configure routing for specific traffic

4. Configure proxychains for traffic routing:
   - Install and configure proxychains
   - Route traffic through Tor
   - Chain multiple proxies

**Deliverable:** A shell script that performs network diagnostics and can switch between different network configurations.

## Exercise 4: Terminal Mastery

**Objective:** Become proficient with terminal usage and command line tools.

**Tasks:**
1. Set up a terminal multiplexer:
   - Install and configure tmux or screen
   - Create a custom configuration file
   - Learn basic commands for window/pane management
   - Create a cheat sheet of keyboard shortcuts

2. Practice file operations:
   - Navigate the file system efficiently
   - Use find, grep, and awk for file searching and manipulation
   - Set up file permissions correctly
   - Create and extract archives in various formats

3. Create useful bash functions:
   - A function to set up a quick HTTP server
   - A function to scan a target and organize results
   - A function to create a new target directory structure
   - A function to take and organize screenshots

4. Set up command logging:
   - Configure your shell to log all commands
   - Set up automatic timestamping
   - Create a script to extract and organize command history

**Deliverable:** Your custom `.zshrc` or `.bashrc` file with all configurations, aliases, and functions.

## Exercise 5: Documentation System Setup

**Objective:** Create an efficient documentation system for penetration testing.

**Tasks:**
1. Set up a note-taking application:
   - Install CherryTree, KeepNote, or configure VS Code
   - Create templates for different phases of penetration testing
   - Set up automatic backups

2. Configure screenshot tools:
   - Install and configure Flameshot or other screenshot tools
   - Create keyboard shortcuts for quick capturing
   - Set up automatic naming and organization

3. Create report templates:
   - Create a template for initial findings
   - Create a template for vulnerability documentation
   - Create a template for the final report

4. Set up version control:
   - Initialize a git repository for your notes and scripts
   - Configure .gitignore for sensitive data
   - Set up regular commits and backups

**Deliverable:** A screenshot of your documentation system and a sample penetration test documentation using your templates.

## Exercise 6: Custom Kali ISO Creation (Advanced)

**Objective:** Create a customized Kali Linux ISO with your preferred tools and configurations.

**Tasks:**
1. Install the necessary tools:
   ```bash
   sudo apt update
   sudo apt install -y live-build cdebootstrap
   ```

2. Clone the Kali ISO build repository:
   ```bash
   git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
   cd live-build-config
   ```

3. Customize the build:
   - Modify package lists in `kali-config/variant-*/package-lists/`
   - Add custom scripts in `kali-config/common/hooks/`
   - Add custom files in `kali-config/common/includes.chroot/`

4. Build the ISO:
   ```bash
   sudo ./build.sh --verbose
   ```

5. Test your custom ISO in a VM.

**Deliverable:** A working custom Kali Linux ISO with your preferred tools and configurations.

## Exercise 7: Kali Linux Hardening

**Objective:** Improve the security of your Kali Linux installation.

**Tasks:**
1. User account security:
   - Change default passwords
   - Create a non-root user for daily use
   - Configure sudo access appropriately

2. SSH hardening:
   - Configure key-based authentication
   - Disable password authentication
   - Change default SSH port
   - Implement fail2ban

3. Firewall configuration:
   - Set up iptables or ufw
   - Create rules to allow necessary traffic
   - Block unnecessary services
   - Test the configuration

4. Disk encryption:
   - Implement LUKS encryption for sensitive partitions
   - Set up encrypted containers for sensitive data
   - Create encrypted backup solutions

**Deliverable:** A shell script that performs security checks on your Kali Linux installation and reports any issues.

## Submission Guidelines

For each exercise:
1. Document your process thoroughly
2. Include screenshots where appropriate
3. Explain any issues encountered and how you resolved them
4. Reflect on what you learned and how it applies to the OSCP exam

Remember, becoming comfortable with Kali Linux is essential for success in the OSCP exam. These exercises will help you build the necessary skills and confidence.
