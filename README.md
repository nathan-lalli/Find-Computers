# Find-Computers

`Find-Computers.ps1` is a PowerShell script designed to enumerate all computer objects within an Active Directory domain. It leverages ADSI Searcher to query AD, retrieves each computer's DNS hostname, and resolves their corresponding IP addresses using DNS lookups. This script is useful for network inventory, auditing, and troubleshooting tasks in Windows environments.

## Usage

**Example:**

```powershell
.\Find-Computers.ps1
```

Output is stored in a CSV file, created in the current working directory.
