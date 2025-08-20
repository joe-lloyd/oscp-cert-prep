# Practice Environment for Penetration Testing

This directory contains resources to help you practice penetration testing concepts in a safe, controlled environment.

## Docker Environment

The `docker-compose.yml` file sets up a complete penetration testing lab with:

1. **DVWA (Damn Vulnerable Web Application)** - A deliberately vulnerable web application for practicing web attacks
2. **Metasploitable 2** - An intentionally vulnerable Linux machine with multiple services
3. **Kali Linux** - A penetration testing distribution with pre-installed tools

### Setup Instructions

1. Install Docker and Docker Compose if you haven't already:
   ```
   # For macOS (using Homebrew)
   brew install docker docker-compose
   ```

2. Start the environment:
   ```
   cd /path/to/01-Penetration-Testing-What-You-Should-Know/resources
   docker-compose up -d
   ```

3. Access the environments:
   - DVWA: http://localhost:8080 (default credentials: admin/password)
   - Metasploitable: Access via services on mapped ports
   - Kali Linux: `docker exec -it kali bash`

4. Network Information:
   - DVWA: 172.20.0.2
   - Metasploitable: 172.20.0.3
   - Kali: 172.20.0.4

5. Stop the environment when done:
   ```
   docker-compose down
   ```

## Practice Scripts

### 1. Reconnaissance Script

The `recon.sh` script demonstrates basic reconnaissance techniques. It performs:
- Whois lookup
- DNS enumeration
- Port scanning
- Service identification

Usage:
```
./recon.sh <target_ip_or_domain>
```

### 2. Methodology Checklist

The `methodology_checklist.py` script provides an interactive checklist to follow during penetration testing. It helps you track your progress through each phase of the methodology.

Usage:
```
python3 methodology_checklist.py
```

## Exercises

Use this environment to practice the exercises from the main lesson:

1. Develop your penetration testing methodology using the Kali container
2. Practice reconnaissance against the Metasploitable machine
3. Document vulnerabilities you find in the DVWA application
4. Create a penetration testing report based on your findings

## Safety Note

This environment is for educational purposes only. The skills learned should only be applied to systems you have permission to test.
