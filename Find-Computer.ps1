function Find-Computers {
    [CmdletBinding()]
    param (
        # Add parameters here
    )

    begin {
        # Comment for users
        Write-Host "Will use the current domain of $env:USERDOMAIN to find computers and their IP addresses."
        Write-Host "Finding computers in the domain..."
        # Initialize a list to hold hostnames
        $hostList = System.Collections.Generic.List[string]
        # Initialize a list to hold IP addresses
        $ipList = System.Collections.Generic.List[string]
    }
    process {
        # Create a DirectorySearcher with a filter for computer objects and their DNS hostnames
        $searcher = [adsisearcher]"(objectClass=computer)"
        $searcher.PropertiesToLoad.Add("dnshostname")
        
        # Find all computer objects in the directory
        $computers = $searcher.FindAll()
        # Iterate through each computer object and extract the DNS hostname
        foreach ($c in $computers) {
            $dns = $c.Properties["dnshostname"]
            $hostList.Add($dns)
        }

        # Iterate through the list of hostnames and find their IP addresses
        foreach ($h in $hostList) {
            # Call the Find-IPByHostName function on each hostname
            $ip = Find-IPByHostName -HostName $h
            # If an IP address was found, add it to the list
            if ($ip) {
                $ipList.Add($ip)
            }
        }

        # Sort the IP addresses and write them to a file
        $ipList | Sort-Object | Out-File -FilePath $PWD\IP_Address_List.csv -Force
    }
    end {
        # Remove variables
        Remove-Variable -Name hostList, ipList, searcher, computers, ip -ErrorAction SilentlyContinue
        # Comment for users
        Write-Host "IP addresses have been written to $PWD\IP_Address_List.csv"
    }
}

function Find-IPByHostName {
    [CmdletBinding()]
    param (
        [string]$HostName
    )

    begin {
        # Initialize an empty string to hold the IP address
        $ipAddress = ""
    }

    process {
        # Attempt to get the IP address for the given hostname
        # If the hostname is not found, return nothing
        try {
            # Attempt to resolve the hostname to an IP address
            $ipAddress = [System.Net.Dns]::GetHostByName($HostName).AddressList[0].IPAddressToString
            # Return the IP address
            return $ipAddress + ","
        } catch {
            return
        }
    }
    end {

    }
}

Find-Computers