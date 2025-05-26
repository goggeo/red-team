# Install the required module
Install-Module Microsoft.Graph

# Import the required module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Directory.Read.All"

# Retrieve all Administrative Units
$adminUnits = Get-MgDirectoryAdministrativeUnit

# Initialize a collection to store the results
$results = @()

# Retrieve all Directory Roles to avoid repetitive API calls
$directoryRoles = Get-MgDirectoryRole

# Iterate through each Administrative Unit
foreach ($unit in $adminUnits) {
    Write-Output "Processing Administrative Unit: $($unit.DisplayName)"

    try {
        # Get all Scoped Role Members for the current Administrative Unit
        $members = Get-MgDirectoryAdministrativeUnitScopedRoleMember -AdministrativeUnitId $unit.Id

        # Retrieve all populated members (users) in the Administrative Unit
        $populatedMembers = Get-MgDirectoryAdministrativeUnitMember -AdministrativeUnitId $unit.Id | Select-Object -ExpandProperty additionalProperties

        # Collect User Principal Names of populated members
        $populatedUserPrincipalNames = $populatedMembers | Where-Object { $_.userPrincipalName } | ForEach-Object { $_.userPrincipalName }

        # If Scoped Role Members exist, extract details
        foreach ($member in $members) {
            # Extract the role member info (e.g., user name and details)
            $roleMember = $member | Select-Object -ExpandProperty roleMemberInfo

            # Retrieve the directory role details for the RoleId
            $roleDetails = $directoryRoles | Where-Object { $_.Id -eq $member.RoleId }

            # Extract the display name of the role, if available
            $roleName = if ($roleDetails) { $roleDetails.DisplayName } else { "Unknown Role" }

            # Add the extracted data to the results
            $results += [pscustomobject]@{
                #AdministrativeUnitId   = $unit.Id
                AdministrativeUnitName = $unit.DisplayName
                #RoleId                 = $member.RoleId
                RoleName               = $roleName
                RoleAssignedUsers             = $roleMember.DisplayName
                #MemberId               = $roleMember.Id
                AUPopulatedUsers         = ($populatedUserPrincipalNames -join ", ") # Join UPNs into a single string
            }
        }

        # If no Scoped Role Members exist but there are populated users, add them to results
        if (-not $members -and $populatedUserPrincipalNames) {
            $results += [pscustomobject]@{
                AdministrativeUnitId   = $unit.Id
                AdministrativeUnitName = $unit.DisplayName
                RoleId                 = "N/A"
                RoleName               = "N/A"
                RoleAssignedUsers              = "N/A"
                MemberId               = "N/A"
                AUPopulatedUsers         = ($populatedUserPrincipalNames -join ", ") # Join UPNs into a single string
            }
        }
    }
    catch {
        Write-Error "Failed to retrieve members for Administrative Unit: $($unit.DisplayName). Error: $_"
    }
}

# Display the results as a table
$results | Format-Table -AutoSize
