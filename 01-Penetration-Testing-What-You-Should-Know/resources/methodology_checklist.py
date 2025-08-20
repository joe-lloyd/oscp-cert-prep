#!/usr/bin/env python3
"""
OSCP Penetration Testing Methodology Checklist
This interactive script helps track progress through each phase of a penetration test.
"""

import os
import json
import datetime
from collections import OrderedDict

# Define the methodology phases and tasks
METHODOLOGY = OrderedDict([
    ("Pre-Engagement", [
        "Define scope and objectives",
        "Establish rules of engagement",
        "Set up documentation system",
        "Prepare testing environment"
    ]),
    ("Information Gathering", [
        "Passive reconnaissance (OSINT)",
        "Domain/IP information lookup",
        "DNS enumeration",
        "Network range identification",
        "Employee/organizational information gathering"
    ]),
    ("Scanning & Enumeration", [
        "Network port scanning",
        "Service version identification",
        "OS fingerprinting",
        "Vulnerability scanning",
        "Service enumeration (SMB, FTP, HTTP, etc.)"
    ]),
    ("Vulnerability Analysis", [
        "Identify potential vulnerabilities",
        "Research discovered services/versions",
        "Prioritize targets based on findings",
        "Map findings to potential exploits",
        "Document all potential attack vectors"
    ]),
    ("Exploitation", [
        "Develop/select appropriate exploits",
        "Test exploits in isolated environment",
        "Execute exploits against targets",
        "Obtain initial access",
        "Document successful/failed attempts"
    ]),
    ("Post-Exploitation", [
        "Establish persistence",
        "Privilege escalation",
        "Internal reconnaissance",
        "Data collection & exfiltration",
        "Lateral movement"
    ]),
    ("Documentation", [
        "Document all findings",
        "Capture screenshots as evidence",
        "Organize notes by machine/vulnerability",
        "Create executive summary",
        "Prepare technical report"
    ])
])

class PentestTracker:
    def __init__(self):
        self.data_file = "pentest_progress.json"
        self.checklist = self._load_or_create_checklist()
        self.target_info = self.checklist.get("target_info", {
            "name": "",
            "ip_range": "",
            "start_date": "",
            "notes": ""
        })
        
    def _load_or_create_checklist(self):
        """Load existing checklist or create a new one"""
        if os.path.exists(self.data_file):
            try:
                with open(self.data_file, 'r') as f:
                    return json.load(f)
            except:
                print("[!] Error loading checklist file. Creating new one.")
        
        # Create new checklist
        checklist = {
            "target_info": {
                "name": "",
                "ip_range": "",
                "start_date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M"),
                "notes": ""
            },
            "phases": {}
        }
        
        # Initialize all phases and tasks
        for phase, tasks in METHODOLOGY.items():
            checklist["phases"][phase] = {
                "complete": False,
                "tasks": {task: {"complete": False, "notes": ""} for task in tasks}
            }
        
        return checklist
    
    def save_checklist(self):
        """Save the current checklist to file"""
        with open(self.data_file, 'w') as f:
            json.dump(self.checklist, f, indent=2)
        print(f"[+] Progress saved to {self.data_file}")
    
    def update_target_info(self):
        """Update target information"""
        print("\n=== Target Information ===")
        self.target_info["name"] = input(f"Target Name [{self.target_info['name']}]: ") or self.target_info["name"]
        self.target_info["ip_range"] = input(f"IP Range [{self.target_info['ip_range']}]: ") or self.target_info["ip_range"]
        self.target_info["notes"] = input(f"Notes [{self.target_info['notes']}]: ") or self.target_info["notes"]
        self.checklist["target_info"] = self.target_info
        self.save_checklist()
    
    def display_progress(self):
        """Display the current progress"""
        os.system('clear' if os.name == 'posix' else 'cls')
        print("=" * 60)
        print(f"OSCP PENETRATION TESTING METHODOLOGY TRACKER")
        print(f"Target: {self.target_info['name']} ({self.target_info['ip_range']})")
        print(f"Started: {self.target_info['start_date']}")
        print("=" * 60)
        
        total_tasks = 0
        completed_tasks = 0
        
        for phase, phase_data in self.checklist["phases"].items():
            phase_tasks = len(phase_data["tasks"])
            phase_completed = sum(1 for task in phase_data["tasks"].values() if task["complete"])
            
            status = f"[{phase_completed}/{phase_tasks}]"
            if phase_completed == phase_tasks:
                phase_status = "✓"
            elif phase_completed > 0:
                phase_status = "⚬"
            else:
                phase_status = " "
                
            print(f"\n{phase_status} {phase} {status}")
            print("-" * 60)
            
            for task_name, task_data in phase_data["tasks"].items():
                status = "✓" if task_data["complete"] else " "
                print(f"  [{status}] {task_name}")
                if task_data["notes"]:
                    for note_line in task_data["notes"].split('\n'):
                        print(f"      → {note_line}")
            
            total_tasks += phase_tasks
            completed_tasks += phase_completed
        
        print("\n" + "=" * 60)
        progress = (completed_tasks / total_tasks) * 100 if total_tasks > 0 else 0
        print(f"Overall Progress: {completed_tasks}/{total_tasks} tasks ({progress:.1f}%)")
        print("=" * 60)
    
    def update_task(self):
        """Update a specific task's status and notes"""
        self.display_progress()
        
        # List phases
        print("\nSelect a phase:")
        phases = list(self.checklist["phases"].keys())
        for i, phase in enumerate(phases, 1):
            print(f"{i}. {phase}")
        
        try:
            phase_idx = int(input("\nEnter phase number: ")) - 1
            if phase_idx < 0 or phase_idx >= len(phases):
                print("[!] Invalid phase number")
                return
        except ValueError:
            print("[!] Please enter a number")
            return
        
        selected_phase = phases[phase_idx]
        phase_data = self.checklist["phases"][selected_phase]
        
        # List tasks
        print(f"\nTasks for {selected_phase}:")
        tasks = list(phase_data["tasks"].keys())
        for i, task in enumerate(tasks, 1):
            status = "✓" if phase_data["tasks"][task]["complete"] else " "
            print(f"{i}. [{status}] {task}")
        
        try:
            task_idx = int(input("\nEnter task number: ")) - 1
            if task_idx < 0 or task_idx >= len(tasks):
                print("[!] Invalid task number")
                return
        except ValueError:
            print("[!] Please enter a number")
            return
        
        selected_task = tasks[task_idx]
        task_data = phase_data["tasks"][selected_task]
        
        # Update task
        print(f"\nUpdating: {selected_task}")
        current_status = "complete" if task_data["complete"] else "incomplete"
        new_status = input(f"Status ({current_status}) [c/i]: ").lower()
        
        if new_status == 'c':
            task_data["complete"] = True
        elif new_status == 'i':
            task_data["complete"] = False
        
        print(f"Current notes: {task_data['notes']}")
        print("Enter new notes (empty line to finish):")
        
        new_notes = []
        while True:
            line = input()
            if not line:
                break
            new_notes.append(line)
        
        if new_notes:
            task_data["notes"] = '\n'.join(new_notes)
        
        # Check if all tasks in phase are complete
        all_complete = all(t["complete"] for t in phase_data["tasks"].values())
        phase_data["complete"] = all_complete
        
        self.save_checklist()
    
    def export_report(self):
        """Export a simple report of the current progress"""
        filename = f"pentest_report_{datetime.datetime.now().strftime('%Y%m%d_%H%M')}.txt"
        
        with open(filename, 'w') as f:
            f.write("=" * 60 + "\n")
            f.write("PENETRATION TESTING REPORT\n")
            f.write("=" * 60 + "\n\n")
            
            f.write(f"Target: {self.target_info['name']}\n")
            f.write(f"IP Range: {self.target_info['ip_range']}\n")
            f.write(f"Start Date: {self.target_info['start_date']}\n")
            f.write(f"Report Date: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n")
            
            if self.target_info['notes']:
                f.write("Target Notes:\n")
                f.write(f"{self.target_info['notes']}\n\n")
            
            f.write("=" * 60 + "\n")
            f.write("METHODOLOGY PROGRESS\n")
            f.write("=" * 60 + "\n\n")
            
            for phase, phase_data in self.checklist["phases"].items():
                phase_status = "COMPLETED" if phase_data["complete"] else "IN PROGRESS"
                f.write(f"{phase} - {phase_status}\n")
                f.write("-" * 60 + "\n")
                
                for task_name, task_data in phase_data["tasks"].items():
                    status = "✓" if task_data["complete"] else "✗"
                    f.write(f"[{status}] {task_name}\n")
                    
                    if task_data["notes"]:
                        f.write("    Notes:\n")
                        for line in task_data["notes"].split('\n'):
                            f.write(f"    → {line}\n")
                    f.write("\n")
                
                f.write("\n")
        
        print(f"[+] Report exported to {filename}")

    def run(self):
        """Main menu loop"""
        while True:
            self.display_progress()
            print("\nOptions:")
            print("1. Update target information")
            print("2. Update task status")
            print("3. Export report")
            print("4. Save and exit")
            
            choice = input("\nEnter choice: ")
            
            if choice == '1':
                self.update_target_info()
            elif choice == '2':
                self.update_task()
            elif choice == '3':
                self.export_report()
            elif choice == '4':
                self.save_checklist()
                print("[+] Checklist saved. Exiting.")
                break
            else:
                print("[!] Invalid choice")

if __name__ == "__main__":
    print("OSCP Penetration Testing Methodology Tracker")
    print("This tool helps you follow a structured methodology during penetration testing.")
    tracker = PentestTracker()
    tracker.run()
