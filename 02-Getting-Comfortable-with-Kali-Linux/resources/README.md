# Kali Linux Resources

This directory contains resources to help you set up and optimize your Kali Linux environment for OSCP preparation.

## Contents

1. **Docker Environment** - A containerized Kali Linux environment for practice
2. **Configuration Scripts** - Automated setup and configuration scripts
3. **Cheat Sheets** - Quick reference guides for Kali Linux tools and commands
4. **Custom Tools** - Additional tools and scripts useful for OSCP preparation

## Setup Instructions

1. Install Docker and Docker Compose if you haven't already:
   ```
   # For macOS (using Homebrew)
   brew install docker docker-compose
   ```

2. Start the Kali Linux Docker environment:
   ```
   cd /path/to/02-Getting-Comfortable-with-Kali-Linux/resources
   docker-compose up -d
   ```

3. Access the Kali Linux container:
   ```
   docker exec -it kali_linux bash
   ```

4. Run the setup script to configure your environment:
   ```
   cd /root/setup
   ./configure_kali.sh
   ```

## Cheat Sheets

The `cheatsheets` directory contains quick reference guides for:

- Kali Linux Terminal Commands
- Network Configuration
- Tool Usage Examples
- Keyboard Shortcuts

## Custom Tools

The `tools` directory contains additional scripts and tools:

- `kali_setup.sh` - Automated environment setup script
- `tool_installer.sh` - Script to install additional tools not included in Kali
- `network_config.sh` - Network configuration helper
- `oscp_dir_setup.sh` - Create OSCP directory structure

## Recommended Resources

### Official Documentation
- [Kali Linux Documentation](https://www.kali.org/docs/)
- [Kali Linux Tools Listing](https://www.kali.org/tools/)
- [Offensive Security OSCP Guide](https://help.offensive-security.com/hc/en-us/articles/360040165632-OSCP-Exam-Guide)

### Books
- "Kali Linux Revealed" - Offensive Security
- "The Hacker Playbook 3" - Peter Kim
- "Penetration Testing: A Hands-On Introduction to Hacking" - Georgia Weidman

### Online Resources
- [Kali Linux Training](https://kali.training/)
- [Offensive Security Blog](https://www.offensive-security.com/blog/)
- [HackTricks](https://book.hacktricks.xyz/)

## Safety Note

These resources are for educational purposes only. The skills learned should only be applied to systems you have permission to test.
