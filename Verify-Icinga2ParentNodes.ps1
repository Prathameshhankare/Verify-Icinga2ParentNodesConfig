# Define the log and CSV file paths
$logFilePath = "PATH\TO\YOUR\Log_File.log"
$outputCsv = "PATH\TO\YOUR\CSV_File.csv"

# Function to log messages to a file
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"

    # Write the message to the console
    Write-Output $logMessage
    # Append the message to the log file
    Add-Content -Path $logFilePath -Value $logMessage
}

# Start with a header in the CSV output
"MachineName,EndpointName,ConfiguredWith,FQDNorIP" | Out-File -FilePath $outputCsv -Encoding UTF8

# Fetch the list of Domain Controller machines
$domainControllers = Get-ADDomainController -Filter *

# Fetch all machines (excluding Domain Controllers)
$allComputers = Get-ADComputer -Filter * -Property Name | Where-Object { $_.Name -like "*SUP*" }

# Combine Domain Controllers and filtered computers
$allMachines = $domainControllers + $allComputers

foreach ($machine in $allMachines) {
    $server = $machine.Name

    Log-Message "Processing $server"

    # Check if the machine is up or down
    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
        Log-Message "$server is up."

        # Check if Icinga2 is installed
        $icingaPath = "\\$server\C$\ProgramData\Icinga2\etc\icinga2\zones.conf"
        if (Test-Path -Path $icingaPath) {
            Log-Message "zones.conf found on $server."

            try {
                $zonesConfContent = Get-Content -Path $icingaPath -ErrorAction Stop -Raw
                $blocks = $zonesConfContent -split 'object Endpoint'

                foreach ($block in $blocks) {
                    if ($block -match 'SUPSAT') {
                        # Extract the endpoint name
                        if ($block -match '\"(.*?)\"') {
                            $endpointName = $matches[1]
                        }

                        # Check if the host parameter is present and if it's FQDN or IP
                        if ($block -match 'host\s*=\s*"([^"]+)"') {
                            $hostValue = $matches[1]
                            
                            # Check if host is FQDN or IP
                            if ($hostValue -match '^[a-zA-Z]') {
                                $isFqdn = "FQDN"
                            } else {
                                $isFqdn = "IP"
                            }

                            Log-Message "Found Endpoint: $endpointName with $isFqdn $hostValue"

                            # Append the details to the CSV file
                            "$server,$endpointName,$isFqdn,$hostValue" | Out-File -FilePath $outputCsv -Append -Encoding UTF8
                        } else {
                            Log-Message "Endpoint $endpointName does not have a host parameter."
                        }
                    }
                }
            } catch {
                Log-Message "Error reading zones.conf on $server : $_"
            }

        } else {
            Log-Message "Icinga2 zones.conf not found on $server."
        }

    } else {
        Log-Message "$server is down."
    }

    Log-Message "Finished processing $server"
}

Log-Message "Script execution completed."
