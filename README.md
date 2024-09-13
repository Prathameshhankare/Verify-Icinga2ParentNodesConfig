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
