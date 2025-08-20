# File Operations Examples

This document provides practical examples of file operations that are essential for penetration testing and the OSCP exam.

## Navigation and Information Gathering

### Finding Files

```bash
# Find files by name
find / -name "password.txt" 2>/dev/null

# Find files by type
find / -type f -name "*.conf" 2>/dev/null

# Find files by permission
find / -perm -4000 2>/dev/null  # Find SUID files
find / -perm -2000 2>/dev/null  # Find SGID files
find / -perm -1000 2>/dev/null  # Find sticky bit files
find / -perm -o+w 2>/dev/null   # Find world-writable files

# Find files by owner
find / -user root -perm -4000 2>/dev/null

# Find files modified in the last 24 hours
find / -type f -mtime -1 2>/dev/null

# Find files accessed in the last hour
find / -type f -amin -60 2>/dev/null

# Find files larger than 100MB
find / -type f -size +100M 2>/dev/null

# Find empty files
find / -type f -empty 2>/dev/null
```

### File Information

```bash
# View file type
file /bin/bash

# View file permissions, owner, size
ls -la /etc/passwd

# View file timestamps (access, modify, change)
stat /etc/passwd

# View file content with line numbers
cat -n /etc/passwd

# View binary files in hex
hexdump -C /bin/ls | head

# View file metadata
exiftool image.jpg
```

## File Manipulation

### Creating and Modifying Files

```bash
# Create empty file
touch newfile.txt

# Create file with content
echo "Hello World" > newfile.txt

# Append to file
echo "Additional line" >> newfile.txt

# Create file with multiple lines
cat << EOF > multiline.txt
Line 1
Line 2
Line 3
EOF

# Edit file with text editor
nano file.txt
vim file.txt

# Create symbolic link
ln -s /path/to/original /path/to/link

# Create hard link
ln /path/to/original /path/to/link
```

### Copying and Moving Files

```bash
# Copy file
cp source.txt destination.txt

# Copy directory recursively
cp -r source_dir/ destination_dir/

# Copy with preservation of attributes
cp -p source.txt destination.txt

# Move/rename file
mv old.txt new.txt

# Move multiple files to directory
mv file1.txt file2.txt directory/

# Copy files over SSH
scp file.txt user@remote:/path/
scp -r directory/ user@remote:/path/
```

### File Permissions

```bash
# Change file owner
chown user:group file.txt

# Change file permissions (numeric)
chmod 755 file.txt  # rwxr-xr-x
chmod 644 file.txt  # rw-r--r--
chmod 600 file.txt  # rw-------

# Change file permissions (symbolic)
chmod u+x file.txt  # Add execute for user
chmod g-w file.txt  # Remove write for group
chmod o= file.txt   # No permissions for others
chmod a+r file.txt  # Add read for all

# Set SUID bit
chmod u+s file.txt

# Set SGID bit
chmod g+s file.txt

# Set sticky bit
chmod +t directory/
```

## File Compression and Archiving

### Tar Archives

```bash
# Create tar archive
tar -cf archive.tar file1 file2 directory/

# Create compressed tar archive (gzip)
tar -czf archive.tar.gz file1 file2 directory/

# Create compressed tar archive (bzip2)
tar -cjf archive.tar.bz2 file1 file2 directory/

# Extract tar archive
tar -xf archive.tar

# Extract compressed tar archive
tar -xzf archive.tar.gz
tar -xjf archive.tar.bz2

# List contents of tar archive
tar -tf archive.tar
```

### Zip Archives

```bash
# Create zip archive
zip -r archive.zip file1 file2 directory/

# Extract zip archive
unzip archive.zip

# List contents of zip archive
unzip -l archive.zip

# Password-protect zip archive
zip -r -e archive.zip file1 file2 directory/
```

### Other Compression Formats

```bash
# Gzip compression
gzip file.txt       # Creates file.txt.gz and removes original
gunzip file.txt.gz  # Extracts and removes .gz

# Bzip2 compression
bzip2 file.txt      # Creates file.txt.bz2 and removes original
bunzip2 file.txt.bz2 # Extracts and removes .bz2

# 7zip (if installed)
7z a archive.7z file1 file2 directory/
7z x archive.7z
```

## File Transfer Techniques

### Using Netcat

```bash
# On receiving machine
nc -lvp 4444 > file.txt

# On sending machine
nc -w 3 [receiver_ip] 4444 < file.txt
```

### Using Python HTTP Server

```bash
# Start HTTP server
python -m SimpleHTTPServer 8000  # Python 2
python3 -m http.server 8000      # Python 3

# Download file using wget
wget http://[server_ip]:8000/file.txt

# Download file using curl
curl -O http://[server_ip]:8000/file.txt
```

### Using FTP

```bash
# Start Python FTP server
python -m pyftpdlib -p 21 -w

# Connect with FTP client
ftp [server_ip]
> get file.txt
> put file.txt
> bye
```

### Using SSH/SCP

```bash
# Copy from local to remote
scp file.txt user@remote:/path/

# Copy from remote to local
scp user@remote:/path/file.txt ./

# Copy directory recursively
scp -r directory/ user@remote:/path/
```

## Special File Operations

### File Descriptors and Redirection

```bash
# Redirect stdout to file
command > file.txt

# Redirect stderr to file
command 2> errors.txt

# Redirect both stdout and stderr to file
command &> all_output.txt
command > all_output.txt 2>&1

# Redirect stdout to one file, stderr to another
command > output.txt 2> errors.txt

# Append stdout to file
command >> file.txt

# Redirect stdin from file
command < input.txt

# Here documents (multi-line input)
cat << EOF > file.txt
Line 1
Line 2
EOF

# Here strings (single-line input)
grep "pattern" <<< "text to search"

# Discard output
command > /dev/null
```

### Special Files and Devices

```bash
# Read from /dev/null (empty)
cat /dev/null

# Read random data
head -c 10 /dev/urandom | hexdump -C

# Read pseudo-random data
head -c 10 /dev/random | hexdump -C

# Write to /dev/null (discard)
echo "useless data" > /dev/null
```

## OSCP Exam Relevance

During the OSCP exam, efficient file operations are crucial for:

1. **Privilege Escalation**: Finding SUID/SGID files, world-writable files, and misconfigured permissions
2. **Data Exfiltration**: Compressing and transferring files between systems
3. **Evidence Collection**: Copying and preserving files for documentation
4. **Payload Delivery**: Creating, modifying, and transferring exploit code
5. **Persistence**: Creating files in specific locations to maintain access
6. **Stealth**: Manipulating file timestamps to avoid detection

Remember that understanding file operations is fundamental to both offensive and defensive security. Many vulnerabilities stem from improper file permissions or unsafe file operations.
