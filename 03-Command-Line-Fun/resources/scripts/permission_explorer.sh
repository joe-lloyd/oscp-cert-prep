#!/bin/bash
# Permission Explorer Script for OSCP
# This script helps practice and understand Linux file permissions

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

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_color "$RED" "This operation requires root privileges. Please run with sudo."
        return 1
    fi
    return 0
}

# Function to create a practice environment
create_practice_env() {
    clear
    print_color "$BLUE" "===== CREATING PERMISSION PRACTICE ENVIRONMENT ====="
    
    # Create a directory for practice
    practice_dir=~/permission_practice
    
    if [ -d "$practice_dir" ]; then
        print_color "$YELLOW" "Practice directory already exists. Do you want to recreate it? (y/n)"
        read -p "> " recreate
        if [[ $recreate == "y" || $recreate == "Y" ]]; then
            rm -rf $practice_dir
        else
            print_color "$YELLOW" "Using existing practice directory."
            return
        fi
    fi
    
    print_color "$YELLOW" "Creating practice environment in $practice_dir..."
    mkdir -p $practice_dir
    cd $practice_dir
    
    # Create various files with different permissions
    print_color "$YELLOW" "Creating files with different permissions..."
    
    # Regular files
    echo "This is a regular file with default permissions." > regular_file.txt
    
    echo "This file is readable by everyone." > readable_file.txt
    chmod 644 readable_file.txt
    
    echo "This file is only readable by the owner." > owner_readable.txt
    chmod 400 owner_readable.txt
    
    echo "This file is executable." > executable_file.sh
    echo "echo 'This script ran successfully!'" >> executable_file.sh
    chmod 755 executable_file.sh
    
    echo "This file has no permissions for anyone." > no_permissions.txt
    chmod 000 no_permissions.txt
    
    # Create directories with different permissions
    print_color "$YELLOW" "Creating directories with different permissions..."
    
    mkdir -p regular_dir
    echo "File in regular directory" > regular_dir/file.txt
    
    mkdir -p restricted_dir
    echo "File in restricted directory" > restricted_dir/file.txt
    chmod 700 restricted_dir
    
    mkdir -p public_dir
    echo "File in public directory" > public_dir/file.txt
    chmod 755 public_dir
    
    # Create files with special permissions
    print_color "$YELLOW" "Creating files with special permissions..."
    
    echo "This file has the setuid bit set." > setuid_file
    chmod 4755 setuid_file
    
    echo "This file has the setgid bit set." > setgid_file
    chmod 2755 setgid_file
    
    echo "This file has the sticky bit set." > sticky_file
    chmod 1755 sticky_file
    
    # Create a symbolic link
    print_color "$YELLOW" "Creating a symbolic link..."
    ln -s regular_file.txt symlink_file
    
    print_color "$GREEN" "Practice environment created successfully in $practice_dir"
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to explain file permissions
explain_permissions() {
    clear
    print_color "$BLUE" "===== FILE PERMISSIONS EXPLAINED ====="
    
    cat << EOF
File permissions in Linux are represented by a 10-character string:

    -rwxrwxrwx

The first character indicates the file type:
    - : Regular file
    d : Directory
    l : Symbolic link
    c : Character device
    b : Block device
    s : Socket
    p : Named pipe

The next 9 characters represent permissions for three categories:
    Owner (User) | Group | Others
    rwx          | rwx   | rwx

Where:
    r : Read permission (4)
    w : Write permission (2)
    x : Execute permission (1)
    - : No permission (0)

Numeric representation:
    Each permission set (Owner, Group, Others) can be represented as a number:
    r = 4, w = 2, x = 1
    
    Examples:
    rwx = 4+2+1 = 7
    r-x = 4+0+1 = 5
    r-- = 4+0+0 = 4
    
    So, rwxr-xr-- would be 754

Special permissions:
    SUID (4000): When set on an executable file, it runs with the permissions of the file owner
    SGID (2000): When set on an executable file, it runs with the permissions of the file group
    Sticky bit (1000): When set on a directory, only the file owner can delete or rename files

Common permission patterns:
    755 (rwxr-xr-x): Common for executable files and directories
    644 (rw-r--r--): Common for regular files
    700 (rwx------): Private directories
    777 (rwxrwxrwx): Full permissions for everyone (generally not recommended)
    400 (r--------): Read-only for owner
EOF
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to demonstrate chmod command
demonstrate_chmod() {
    clear
    print_color "$BLUE" "===== CHMOD COMMAND DEMONSTRATION ====="
    
    # Check if practice environment exists
    practice_dir=~/permission_practice
    if [ ! -d "$practice_dir" ]; then
        print_color "$RED" "Practice environment not found. Please create it first."
        return
    fi
    
    cd $practice_dir
    
    print_color "$YELLOW" "Current files and their permissions:"
    ls -la
    
    echo
    print_color "$GREEN" "Let's modify permissions of a file:"
    echo "1. Using symbolic notation (e.g., u+x, g-w, o=r)"
    echo "2. Using numeric notation (e.g., 755, 644)"
    read -p "Choose a method (1/2): " method_choice
    
    if [ "$method_choice" == "1" ]; then
        print_color "$YELLOW" "Using symbolic notation:"
        echo "Examples:"
        echo "  u+x : Add execute permission for the owner"
        echo "  g-w : Remove write permission for the group"
        echo "  o=r : Set read-only permission for others"
        echo "  a+x : Add execute permission for all (owner, group, others)"
        echo "  u+rwx,g+rx,o+r : Add rwx for owner, rx for group, r for others"
        
        read -p "Enter the file name to modify: " file_name
        
        if [ ! -e "$file_name" ]; then
            print_color "$RED" "File not found: $file_name"
            return
        fi
        
        print_color "$YELLOW" "Current permissions for $file_name:"
        ls -la "$file_name"
        
        read -p "Enter the chmod symbolic notation: " chmod_notation
        
        print_color "$YELLOW" "Executing: chmod $chmod_notation $file_name"
        chmod $chmod_notation $file_name
        
        print_color "$GREEN" "New permissions for $file_name:"
        ls -la "$file_name"
    else
        print_color "$YELLOW" "Using numeric notation:"
        echo "Examples:"
        echo "  755 : rwxr-xr-x (Owner: rwx, Group: r-x, Others: r-x)"
        echo "  644 : rw-r--r-- (Owner: rw-, Group: r--, Others: r--)"
        echo "  700 : rwx------ (Owner: rwx, Group: ---, Others: ---)"
        echo "  777 : rwxrwxrwx (Owner: rwx, Group: rwx, Others: rwx)"
        
        read -p "Enter the file name to modify: " file_name
        
        if [ ! -e "$file_name" ]; then
            print_color "$RED" "File not found: $file_name"
            return
        fi
        
        print_color "$YELLOW" "Current permissions for $file_name:"
        ls -la "$file_name"
        
        read -p "Enter the chmod numeric notation: " chmod_notation
        
        print_color "$YELLOW" "Executing: chmod $chmod_notation $file_name"
        chmod $chmod_notation $file_name
        
        print_color "$GREEN" "New permissions for $file_name:"
        ls -la "$file_name"
    fi
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to demonstrate chown and chgrp commands
demonstrate_ownership() {
    clear
    print_color "$BLUE" "===== CHOWN AND CHGRP DEMONSTRATION ====="
    
    # Check if practice environment exists
    practice_dir=~/permission_practice
    if [ ! -d "$practice_dir" ]; then
        print_color "$RED" "Practice environment not found. Please create it first."
        return
    fi
    
    cd $practice_dir
    
    print_color "$YELLOW" "Current files and their ownership:"
    ls -la
    
    echo
    print_color "$GREEN" "Let's modify ownership of a file:"
    echo "1. Change owner (chown)"
    echo "2. Change group (chgrp)"
    echo "3. Change both owner and group (chown owner:group)"
    read -p "Choose an operation (1/2/3): " op_choice
    
    read -p "Enter the file name to modify: " file_name
    
    if [ ! -e "$file_name" ]; then
        print_color "$RED" "File not found: $file_name"
        return
    fi
    
    print_color "$YELLOW" "Current ownership for $file_name:"
    ls -la "$file_name"
    
    if [ "$op_choice" == "1" ]; then
        print_color "$YELLOW" "Available users:"
        cut -d: -f1 /etc/passwd | head -10
        read -p "Enter the new owner: " new_owner
        
        if check_root; then
            print_color "$YELLOW" "Executing: chown $new_owner $file_name"
            chown $new_owner $file_name
            
            print_color "$GREEN" "New ownership for $file_name:"
            ls -la "$file_name"
        fi
    elif [ "$op_choice" == "2" ]; then
        print_color "$YELLOW" "Available groups:"
        cut -d: -f1 /etc/group | head -10
        read -p "Enter the new group: " new_group
        
        if check_root; then
            print_color "$YELLOW" "Executing: chgrp $new_group $file_name"
            chgrp $new_group $file_name
            
            print_color "$GREEN" "New ownership for $file_name:"
            ls -la "$file_name"
        fi
    else
        print_color "$YELLOW" "Available users:"
        cut -d: -f1 /etc/passwd | head -10
        read -p "Enter the new owner: " new_owner
        
        print_color "$YELLOW" "Available groups:"
        cut -d: -f1 /etc/group | head -10
        read -p "Enter the new group: " new_group
        
        if check_root; then
            print_color "$YELLOW" "Executing: chown $new_owner:$new_group $file_name"
            chown $new_owner:$new_group $file_name
            
            print_color "$GREEN" "New ownership for $file_name:"
            ls -la "$file_name"
        fi
    fi
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to demonstrate special permissions
demonstrate_special_permissions() {
    clear
    print_color "$BLUE" "===== SPECIAL PERMISSIONS DEMONSTRATION ====="
    
    # Check if practice environment exists
    practice_dir=~/permission_practice
    if [ ! -d "$practice_dir" ]; then
        print_color "$RED" "Practice environment not found. Please create it first."
        return
    fi
    
    cd $practice_dir
    
    print_color "$YELLOW" "Special permissions in Linux:"
    cat << EOF
1. SUID (Set User ID) - 4000
   When set on an executable file, it runs with the permissions of the file owner
   Symbolic notation: chmod u+s file
   Numeric notation: chmod 4xxx file
   Example: chmod 4755 file (rwsr-xr-x)

2. SGID (Set Group ID) - 2000
   When set on an executable file, it runs with the permissions of the file group
   When set on a directory, new files created in the directory inherit the group of the directory
   Symbolic notation: chmod g+s file
   Numeric notation: chmod 2xxx file
   Example: chmod 2755 file (rwxr-sr-x)

3. Sticky Bit - 1000
   When set on a directory, only the file owner can delete or rename files
   Commonly used on /tmp directory
   Symbolic notation: chmod +t directory
   Numeric notation: chmod 1xxx directory
   Example: chmod 1777 directory (rwxrwxrwt)
EOF
    
    print_color "$GREEN" "Files with special permissions in the practice environment:"
    ls -la | grep -E '^.{4}[sStT]'
    
    echo
    print_color "$GREEN" "Let's set special permissions on a file:"
    echo "1. Set SUID"
    echo "2. Set SGID"
    echo "3. Set Sticky Bit"
    read -p "Choose an operation (1/2/3): " op_choice
    
    read -p "Enter the file name to modify: " file_name
    
    if [ ! -e "$file_name" ]; then
        print_color "$RED" "File not found: $file_name"
        return
    fi
    
    print_color "$YELLOW" "Current permissions for $file_name:"
    ls -la "$file_name"
    
    if [ "$op_choice" == "1" ]; then
        print_color "$YELLOW" "Setting SUID bit..."
        chmod u+s "$file_name"
    elif [ "$op_choice" == "2" ]; then
        print_color "$YELLOW" "Setting SGID bit..."
        chmod g+s "$file_name"
    else
        print_color "$YELLOW" "Setting Sticky Bit..."
        chmod +t "$file_name"
    fi
    
    print_color "$GREEN" "New permissions for $file_name:"
    ls -la "$file_name"
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to demonstrate access control lists (ACLs)
demonstrate_acls() {
    clear
    print_color "$BLUE" "===== ACCESS CONTROL LISTS (ACLs) DEMONSTRATION ====="
    
    # Check if practice environment exists
    practice_dir=~/permission_practice
    if [ ! -d "$practice_dir" ]; then
        print_color "$RED" "Practice environment not found. Please create it first."
        return
    fi
    
    # Check if ACL commands are available
    if ! command -v getfacl &> /dev/null || ! command -v setfacl &> /dev/null; then
        print_color "$RED" "ACL commands (getfacl, setfacl) not found. Please install acl package."
        return
    fi
    
    cd $practice_dir
    
    print_color "$YELLOW" "Access Control Lists (ACLs) allow for more fine-grained permission control"
    print_color "$YELLOW" "beyond the traditional user/group/others model."
    
    echo
    print_color "$GREEN" "Let's create a file with ACLs:"
    echo "This file will have ACLs applied to it." > acl_file.txt
    
    print_color "$YELLOW" "Current permissions for acl_file.txt:"
    ls -la acl_file.txt
    
    echo
    print_color "$GREEN" "Let's view the current ACLs:"
    getfacl acl_file.txt
    
    echo
    print_color "$GREEN" "Let's add an ACL entry for a specific user:"
    print_color "$YELLOW" "Available users:"
    cut -d: -f1 /etc/passwd | head -10
    read -p "Enter a username: " acl_user
    
    print_color "$YELLOW" "Setting read and write permissions for $acl_user..."
    if check_root; then
        setfacl -m u:$acl_user:rw acl_file.txt
        
        print_color "$GREEN" "New ACLs for acl_file.txt:"
        getfacl acl_file.txt
        
        print_color "$YELLOW" "Notice the '+' at the end of the permissions in ls output:"
        ls -la acl_file.txt
    fi
    
    echo
    print_color "$GREEN" "Let's add an ACL entry for a specific group:"
    print_color "$YELLOW" "Available groups:"
    cut -d: -f1 /etc/group | head -10
    read -p "Enter a group name: " acl_group
    
    print_color "$YELLOW" "Setting read-only permissions for group $acl_group..."
    if check_root; then
        setfacl -m g:$acl_group:r acl_file.txt
        
        print_color "$GREEN" "New ACLs for acl_file.txt:"
        getfacl acl_file.txt
    fi
    
    echo
    print_color "$GREEN" "To remove an ACL entry:"
    print_color "$YELLOW" "setfacl -x u:username file (remove specific user entry)"
    print_color "$YELLOW" "setfacl -x g:groupname file (remove specific group entry)"
    print_color "$YELLOW" "setfacl -b file (remove all ACL entries)"
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to demonstrate umask
demonstrate_umask() {
    clear
    print_color "$BLUE" "===== UMASK DEMONSTRATION ====="
    
    print_color "$YELLOW" "The umask determines the default permissions for newly created files and directories."
    print_color "$YELLOW" "It is a mask that is subtracted from the maximum permissions:"
    print_color "$YELLOW" "  - Maximum for files: 666 (rw-rw-rw-)"
    print_color "$YELLOW" "  - Maximum for directories: 777 (rwxrwxrwx)"
    
    echo
    print_color "$GREEN" "Current umask value:"
    umask
    
    echo
    print_color "$GREEN" "Current umask in symbolic notation:"
    umask -S
    
    echo
    print_color "$GREEN" "Let's see how umask affects new files and directories:"
    
    # Create a temporary directory
    temp_dir=$(mktemp -d)
    cd $temp_dir
    
    print_color "$YELLOW" "Creating a new file and directory with current umask..."
    touch new_file
    mkdir new_dir
    
    print_color "$GREEN" "Permissions for new file:"
    ls -la new_file
    
    print_color "$GREEN" "Permissions for new directory:"
    ls -ld new_dir
    
    echo
    print_color "$GREEN" "Let's change the umask temporarily:"
    print_color "$YELLOW" "Common umask values:"
    print_color "$YELLOW" "  - 022: Default on many systems (files: 644, directories: 755)"
    print_color "$YELLOW" "  - 027: More restrictive (files: 640, directories: 750)"
    print_color "$YELLOW" "  - 077: Most restrictive (files: 600, directories: 700)"
    
    read -p "Enter a new umask value (e.g., 022, 027, 077): " new_umask
    
    print_color "$YELLOW" "Setting umask to $new_umask..."
    umask $new_umask
    
    print_color "$GREEN" "New umask value:"
    umask
    
    print_color "$YELLOW" "Creating a new file and directory with new umask..."
    touch new_file_2
    mkdir new_dir_2
    
    print_color "$GREEN" "Permissions for new file with new umask:"
    ls -la new_file_2
    
    print_color "$GREEN" "Permissions for new directory with new umask:"
    ls -ld new_dir_2
    
    # Clean up
    cd
    rm -rf $temp_dir
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Function to run permission challenges
permission_challenges() {
    clear
    print_color "$BLUE" "===== PERMISSION CHALLENGES ====="
    
    # Check if practice environment exists
    practice_dir=~/permission_practice
    if [ ! -d "$practice_dir" ]; then
        print_color "$RED" "Practice environment not found. Please create it first."
        return
    fi
    
    cd $practice_dir
    
    print_color "$YELLOW" "These challenges will test your understanding of file permissions."
    print_color "$YELLOW" "Try to solve them using the knowledge you've gained."
    
    echo
    print_color "$GREEN" "Challenge 1: Access a file with no permissions"
    print_color "$YELLOW" "Try to read the content of 'no_permissions.txt' without changing its permissions."
    print_color "$YELLOW" "Hint: Think about file ownership and root privileges."
    
    echo
    print_color "$GREEN" "Challenge 2: Create a file that only you can read and write"
    print_color "$YELLOW" "Create a file named 'private_file.txt' with content, and set permissions so only you can read/write."
    print_color "$YELLOW" "Verify with ls -la that the permissions are correct."
    
    echo
    print_color "$GREEN" "Challenge 3: Create a directory structure with specific permissions"
    print_color "$YELLOW" "Create a directory structure as follows:"
    print_color "$YELLOW" "  - A directory named 'project' (rwxr-x---)"
    print_color "$YELLOW" "  - Inside 'project', a subdirectory named 'public' (rwxr-xr-x)"
    print_color "$YELLOW" "  - Inside 'project', a subdirectory named 'private' (rwx------)"
    print_color "$YELLOW" "  - A file in 'public' named 'readme.txt' (rw-r--r--)"
    print_color "$YELLOW" "  - A file in 'private' named 'secret.txt' (rw-------)"
    
    echo
    print_color "$GREEN" "Challenge 4: Set up a shared directory"
    print_color "$YELLOW" "Create a directory named 'shared' where:"
    print_color "$YELLOW" "  - You have full permissions"
    print_color "$YELLOW" "  - Your group has read and execute permissions"
    print_color "$YELLOW" "  - Others have no permissions"
    print_color "$YELLOW" "  - New files created in the directory inherit the group ownership (SGID)"
    
    echo
    print_color "$GREEN" "Challenge 5: Fix broken permissions"
    print_color "$YELLOW" "The script 'executable_file.sh' should be executable. Try to run it."
    print_color "$YELLOW" "If it doesn't work, fix the permissions and try again."
    
    print_color "$YELLOW" "Press Enter when you're ready to see solutions..."
    read
    
    clear
    print_color "$BLUE" "===== CHALLENGE SOLUTIONS ====="
    
    echo
    print_color "$GREEN" "Challenge 1 Solution:"
    print_color "$YELLOW" "To read a file with no permissions without changing permissions:"
    print_color "$YELLOW" "1. If you're the owner: cat no_permissions.txt (won't work)"
    print_color "$YELLOW" "2. As root: sudo cat no_permissions.txt (will work)"
    
    echo
    print_color "$GREEN" "Challenge 2 Solution:"
    print_color "$YELLOW" "echo 'This is private content' > private_file.txt"
    print_color "$YELLOW" "chmod 600 private_file.txt"
    print_color "$YELLOW" "ls -la private_file.txt # Should show -rw-------"
    
    echo
    print_color "$GREEN" "Challenge 3 Solution:"
    print_color "$YELLOW" "mkdir -p project/public project/private"
    print_color "$YELLOW" "chmod 750 project"
    print_color "$YELLOW" "chmod 755 project/public"
    print_color "$YELLOW" "chmod 700 project/private"
    print_color "$YELLOW" "echo 'Public readme' > project/public/readme.txt"
    print_color "$YELLOW" "chmod 644 project/public/readme.txt"
    print_color "$YELLOW" "echo 'Secret information' > project/private/secret.txt"
    print_color "$YELLOW" "chmod 600 project/private/secret.txt"
    
    echo
    print_color "$GREEN" "Challenge 4 Solution:"
    print_color "$YELLOW" "mkdir shared"
    print_color "$YELLOW" "chmod 750 shared"
    print_color "$YELLOW" "chmod g+s shared # Set SGID bit"
    print_color "$YELLOW" "ls -ld shared # Should show drwxr-s---"
    
    echo
    print_color "$GREEN" "Challenge 5 Solution:"
    print_color "$YELLOW" "chmod +x executable_file.sh"
    print_color "$YELLOW" "./executable_file.sh # Should now execute"
    
    print_color "$YELLOW" "Press Enter to continue..."
    read
}

# Main menu
main_menu() {
    while true; do
        clear
        print_color "$BLUE" "===== PERMISSION EXPLORER TOOL ====="
        print_color "$YELLOW" "Select an option:"
        echo "1. Create Practice Environment"
        echo "2. Explain File Permissions"
        echo "3. Demonstrate chmod Command"
        echo "4. Demonstrate chown and chgrp Commands"
        echo "5. Demonstrate Special Permissions"
        echo "6. Demonstrate Access Control Lists (ACLs)"
        echo "7. Demonstrate umask"
        echo "8. Permission Challenges"
        echo "9. Exit"
        
        read -p "Enter your choice (1-9): " choice
        
        case $choice in
            1) create_practice_env ;;
            2) explain_permissions ;;
            3) demonstrate_chmod ;;
            4) demonstrate_ownership ;;
            5) demonstrate_special_permissions ;;
            6) demonstrate_acls ;;
            7) demonstrate_umask ;;
            8) permission_challenges ;;
            9) 
                print_color "$GREEN" "Thank you for exploring file permissions!"
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
print_color "$GREEN" "Welcome to the Permission Explorer Tool!"
print_color "$YELLOW" "This tool will help you understand and practice Linux file permissions for OSCP."
echo
print_color "$YELLOW" "Press Enter to continue..."
read
main_menu
