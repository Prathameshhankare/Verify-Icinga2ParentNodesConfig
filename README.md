# Verify-Icinga2ParentNodesConfig
The PowerShell script to verify if the Icinga2 Client Parent Node is configured using FQDN or IP address

## Overview
This PowerShell script automates the process of checking Domain Controller machines and other machines with `SUP` in their hostname for Icinga2 endpoint configuration. The script retrieves information from the `zones.conf` file on each machine, logs the status, and exports endpoint details to a CSV file.

## Features
- Checks if machines (Domain Controllers or machines with `SUP` in their name) are up or down.
- Validates the presence of the `zones.conf` file for Icinga2 configuration.
- Extracts `SUPSAT` endpoints from the `zones.conf` file and identifies whether they are configured with an FQDN or an IP address.
- Logs detailed information and exports findings to a CSV file.

## Requirements
- PowerShell
- Active Directory module (for `Get-ADDomainController` and `Get-ADComputer`)
- Icinga2 installed on the machines to be checked
- Proper permissions to access the `zones.conf` file located on the remote machines

## Installation
1. Clone or download the repository to your local machine.
2. Ensure the Active Directory module is installed by running the following command in PowerShell:
   ```powershell
   Install-WindowsFeature -Name RSAT-AD-PowerShell
   ```
3. Update the log and CSV file paths in the script to your desired locations:
  ```powershell
  $logFilePath = "\PATH\TO\YOUR\LOG_File.log"
  $outputCsv = "\PATH\TO\YOUR\CSV_File.csv"
  ```
## Usage
1. Open PowerShell with administrative privileges.
2. Run the script:
   ```powershell
   .\Verify-Icinga2SUPSATParentNodes.ps1
   ```
3. The script will:
   - Log the status of each machine in the specified log file.
   - Export endpoint details to the specified CSV file.
  
## Output
- **Log file**: Contains a step-by-step log of the script's execution, including machine statuses, file checks, and any errors encountered.
- **CSV file**: Contains a list of endpoints with details on whether they are configured with an FQDN or IP, along with the machine name.

## Example Log Output
```log
2024-09-13 12:00:00 - Processing Server1
2024-09-13 12:00:01 - Server1 is up.
2024-09-13 12:00:02 - zones.conf found on Server1.
2024-09-13 12:00:03 - Found Endpoint: XXSUPSATXX with FQDN icinga.example.com
2024-09-13 12:00:04 - Finished processing Server1
2024-09-13 12:00:05 - Processing Server2
2024-09-13 12:00:06 - Server2 is up.
2024-09-13 12:00:07 - zones.conf found on Server2.
2024-09-13 12:00:08 - Found Endpoint: XXSUPSATXX with IP 192.168.1.100
2024-09-13 12:00:09 - Finished processing Server2
2024-09-13 12:00:10 - Script execution completed.
```

## Example CSV Output
```text
MachineName,EndpointName,ConfiguredWith,FQDNorIP
Server1,XXSUPSATXX,FQDN,icinga.example.com
Server2,XXSUPSATXX,IP,192.168.1.100
```
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


