# Practical Tools Resources

This directory contains resources to support your learning and practice with the practical tools covered in this module. These resources are designed to help you prepare for the OSCP exam by providing hands-on experience with various penetration testing tools.

## Directory Structure

- `docker/` - Docker environment for practicing with tools
- `scripts/` - Utility scripts for tool automation and practice
- `cheatsheets/` - Quick reference guides for various tools
- `wordlists/` - Custom wordlists for different testing scenarios
- `vulnerable_apps/` - Vulnerable applications for practice

## Docker Environment

The Docker environment provides a controlled network with multiple vulnerable targets for practicing the tools covered in this module. The environment includes:

- Kali Linux container with all necessary tools installed
- Multiple vulnerable machines with different operating systems and services
- Isolated network for safe practice

### Setup Instructions

1. Install Docker and Docker Compose if not already installed
2. Navigate to the `docker` directory
3. Run `docker-compose up -d` to start the environment
4. Connect to the Kali container using `docker exec -it kali_container bash`
5. Begin practicing with the tools against the provided targets

## Scripts

The `scripts` directory contains utility scripts to help you automate common tasks and practice with various tools. These scripts include:

- Tool wrappers for simplified usage
- Automation scripts for reconnaissance and scanning
- Custom exploitation scripts
- Post-exploitation utilities

## Cheatsheets

The `cheatsheets` directory contains quick reference guides for the tools covered in this module. These cheatsheets include:

- Common commands and options
- Usage examples
- Best practices
- OSCP-specific tips

## Wordlists

The `wordlists` directory contains custom wordlists for different testing scenarios, including:

- Directory and file enumeration
- Password cracking
- Subdomain discovery
- Parameter fuzzing

## Vulnerable Applications

The `vulnerable_apps` directory contains vulnerable applications for practicing exploitation techniques. These applications include:

- Web applications with common vulnerabilities
- Network services with known vulnerabilities
- Custom applications designed to teach specific exploitation techniques

## Additional Resources

### Recommended Tools

1. **Information Gathering**
   - Nmap
   - DNSRecon
   - theHarvester
   - Recon-ng

2. **Vulnerability Assessment**
   - OpenVAS
   - Nessus Essentials
   - Nikto
   - enum4linux

3. **Web Application Testing**
   - Burp Suite
   - OWASP ZAP
   - Gobuster/Dirbuster
   - SQLmap

4. **Exploitation**
   - Metasploit Framework
   - SearchSploit
   - Immunity Debugger
   - Custom exploit scripts

5. **Password Attacks**
   - Hydra
   - John the Ripper
   - Hashcat
   - Mimikatz

6. **Post-Exploitation**
   - LinPEAS/WinPEAS
   - PowerUp/PowerView
   - Mimikatz
   - CrackMapExec

### External Resources

- [OSCP Exam Guide](https://help.offensive-security.com/hc/en-us/articles/360040165632-OSCP-Exam-Guide)
- [Offensive Security's PWK Course](https://www.offensive-security.com/pwk-oscp/)
- [Kali Linux Tools Documentation](https://www.kali.org/tools/)
- [Exploit Database](https://www.exploit-db.com/)
- [HackTricks](https://book.hacktricks.xyz/)
- [GTFOBins](https://gtfobins.github.io/)
- [LOLBAS](https://lolbas-project.github.io/)

## Usage Guidelines

1. **Practice Ethically**: Only use these tools and resources in controlled environments or with proper authorization.
2. **Document Your Work**: Keep detailed notes of your methodology and findings.
3. **Understand the Tools**: Don't just run tools; understand how they work and what they're doing.
4. **Develop a Methodology**: Use these resources to develop a systematic approach to penetration testing.
5. **Combine Tools**: Learn how to effectively combine different tools to achieve your objectives.

## OSCP Exam Tips

1. **Time Management**: Practice using these tools efficiently to manage your time during the exam.
2. **Manual Verification**: Always manually verify tool findings to avoid false positives.
3. **Tool Limitations**: Understand the limitations of automated tools and when manual techniques are necessary.
4. **Metasploit Restrictions**: Remember that Metasploit usage is restricted in the OSCP exam.
5. **Documentation**: Practice documenting your findings clearly and concisely for the exam report.
