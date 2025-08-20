# Regular Expressions (Regex) Cheat Sheet for OSCP

Regular expressions are powerful patterns used to match character combinations in strings. They're essential for text processing, data extraction, and validation in penetration testing.

## Basic Patterns

| Pattern | Description | Example |
|---------|-------------|---------|
| `.` | Matches any single character except newline | `a.c` matches "abc", "a1c", "a@c", etc. |
| `^` | Matches start of a line | `^root` matches lines starting with "root" |
| `$` | Matches end of a line | `bash$` matches lines ending with "bash" |
| `*` | Matches 0 or more of the preceding character | `10*1` matches "11", "101", "1001", etc. |
| `+` | Matches 1 or more of the preceding character | `10+1` matches "101", "1001", but not "11" |
| `?` | Matches 0 or 1 of the preceding character | `10?1` matches "11" and "101" |
| `\` | Escapes special characters | `\.` matches a literal period |

## Character Classes

| Pattern | Description | Example |
|---------|-------------|---------|
| `[abc]` | Matches any character in the brackets | `[abc]` matches "a", "b", or "c" |
| `[^abc]` | Matches any character NOT in the brackets | `[^abc]` matches any character except "a", "b", or "c" |
| `[a-z]` | Matches any character in the range | `[a-z]` matches any lowercase letter |
| `[0-9]` | Matches any digit | `[0-9]` matches any single digit |
| `[a-zA-Z]` | Matches any letter | `[a-zA-Z]` matches any letter regardless of case |
| `[a-zA-Z0-9]` | Matches any alphanumeric character | `[a-zA-Z0-9]` matches any letter or digit |

## Shorthand Character Classes

| Pattern | Description | Equivalent |
|---------|-------------|------------|
| `\d` | Matches any digit | `[0-9]` |
| `\D` | Matches any non-digit | `[^0-9]` |
| `\w` | Matches any word character | `[a-zA-Z0-9_]` |
| `\W` | Matches any non-word character | `[^a-zA-Z0-9_]` |
| `\s` | Matches any whitespace character | `[ \t\n\r\f\v]` |
| `\S` | Matches any non-whitespace character | `[^ \t\n\r\f\v]` |

## Quantifiers

| Pattern | Description | Example |
|---------|-------------|---------|
| `{n}` | Matches exactly n occurrences | `a{3}` matches "aaa" |
| `{n,}` | Matches n or more occurrences | `a{2,}` matches "aa", "aaa", etc. |
| `{n,m}` | Matches between n and m occurrences | `a{2,4}` matches "aa", "aaa", "aaaa" |
| `*` | Matches 0 or more occurrences | `a*` matches "", "a", "aa", etc. |
| `+` | Matches 1 or more occurrences | `a+` matches "a", "aa", etc. |
| `?` | Matches 0 or 1 occurrence | `a?` matches "" or "a" |

## Groups and Alternation

| Pattern | Description | Example |
|---------|-------------|---------|
| `(...)` | Creates a capture group | `(abc)+` matches "abc", "abcabc", etc. |
| `(?:...)` | Creates a non-capturing group | `(?:abc)+` same as above but doesn't capture |
| `\1, \2, ...` | Backreferences to capture groups | `(a)(b)\2\1` matches "abba" |
| `\|` | Alternation (OR) | `cat\|dog` matches "cat" or "dog" |

## Anchors and Boundaries

| Pattern | Description | Example |
|---------|-------------|---------|
| `^` | Start of line | `^root` matches "root" at start of line |
| `$` | End of line | `root$` matches "root" at end of line |
| `\b` | Word boundary | `\bcat\b` matches "cat" as a whole word |
| `\B` | Non-word boundary | `\Bcat\B` matches "cat" only if it's inside a word |
| `\A` | Start of string | `\Aroot` matches "root" at start of string |
| `\Z` | End of string | `root\Z` matches "root" at end of string |

## POSIX Character Classes

| Pattern | Description |
|---------|-------------|
| `[:alnum:]` | Alphanumeric characters |
| `[:alpha:]` | Alphabetic characters |
| `[:digit:]` | Digits |
| `[:lower:]` | Lowercase letters |
| `[:upper:]` | Uppercase letters |
| `[:space:]` | Whitespace characters |
| `[:punct:]` | Punctuation characters |

## Common Regex Patterns for OSCP

### IP Address Matching
```regex
\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b
```

### Email Address Matching
```regex
\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b
```

### URL Matching
```regex
https?://(?:[-\w.]|(?:%[\da-fA-F]{2}))+(?::\d+)?(?:/[-\w%!$&'()*+,;=:@/~]+)*(?:\?[-\w%!$&'()*+,;=:@/~]*)?(?:#[-\w%!$&'()*+,;=:@/~]*)?
```

### MAC Address Matching
```regex
(?:[0-9A-Fa-f]{2}[:-]){5}(?:[0-9A-Fa-f]{2})
```

### Username/Password Pattern in Files
```regex
(?:username|user|login|password|pass|pwd).*[=:].+
```

### Finding Potential API Keys
```regex
[A-Za-z0-9]{32,}
```

### Credit Card Numbers
```regex
(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})
```

### Social Security Numbers (US)
```regex
\b(?:\d{3}-\d{2}-\d{4}|\d{9})\b
```

### Finding Base64 Encoded Data
```regex
(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?
```

## Command Line Tools with Regex

### grep
```bash
# Basic grep with regex
grep -E "pattern" file.txt

# Case insensitive search
grep -i "pattern" file.txt

# Recursive search
grep -r "pattern" /path/to/directory

# Show only matching part
grep -o "pattern" file.txt

# Count matches
grep -c "pattern" file.txt

# Invert match (lines that don't match)
grep -v "pattern" file.txt

# Match whole word
grep -w "word" file.txt
```

### sed
```bash
# Replace first occurrence in each line
sed 's/pattern/replacement/' file.txt

# Replace all occurrences in each line
sed 's/pattern/replacement/g' file.txt

# Replace with case insensitivity
sed 's/pattern/replacement/gi' file.txt

# Delete lines matching pattern
sed '/pattern/d' file.txt

# Print only lines matching pattern
sed -n '/pattern/p' file.txt

# Replace in specific line range
sed '1,10 s/pattern/replacement/g' file.txt
```

### awk
```bash
# Print lines matching pattern
awk '/pattern/ {print}' file.txt

# Print specific fields where pattern matches
awk '/pattern/ {print $1,$3}' file.txt

# Use regex in conditions
awk '$1 ~ /^[0-9]+$/ {print $0}' file.txt

# Count lines matching pattern
awk '/pattern/ {count++} END {print count}' file.txt
```

## OSCP-Relevant Examples

### Extract IP Addresses from a Log File
```bash
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" logfile.txt | sort | uniq
```

### Find Potential Passwords in Configuration Files
```bash
grep -r -E "password.*[=:].+" /etc/ 2>/dev/null
```

### Extract Email Addresses from a File
```bash
grep -oE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b" file.txt
```

### Find Files with SUID Bit Set
```bash
find / -perm -u=s -type f 2>/dev/null
```

### Extract URLs from HTML Content
```bash
grep -oE "https?://[^[:space:]\"']+" webpage.html
```

### Find Files Modified in the Last 24 Hours
```bash
find / -type f -mtime -1 2>/dev/null
```

### Extract Usernames from /etc/passwd
```bash
awk -F: '{print $1}' /etc/passwd
```

### Find Writable Directories for Privilege Escalation
```bash
find / -writable -type d 2>/dev/null
```

## Tips for OSCP Exam

1. **Test your regex patterns** before using them in critical operations
2. **Use capture groups** to extract specific parts of matched patterns
3. **Combine regex with other tools** like `sort`, `uniq`, and `cut` for powerful data processing
4. **Use non-greedy quantifiers** (`*?`, `+?`) when matching between delimiters
5. **Escape special characters** when searching for literal characters
6. **Use word boundaries** (`\b`) to match whole words and avoid partial matches
7. **Remember that different tools** may use slightly different regex syntax
8. **Document your complex regex patterns** for future reference
