# PowerShell Script to check which Apps have the "full_acces_as_app" EWS role, so can read all Mailboxes
# There might be ApplicationAccessPolicies in place that afterwards restrict access to only certain mailboxes, so criticality would be reduced
# This is reflected in the output as well.
# This was written for PowerShell 7 - to work with PS v5 you need to exchange some modules and calls

# Check if ExchangeOnlineManagement module is available
$ExchangeOnlineModule = Get-Module -Name ExchangeOnlineManagement -ListAvailable

# Check if Az.Accounts module is available
$AzAccountsModule = Get-Module -Name Az.Accounts -ListAvailable

# If ExchangeOnlineManagement module is not available, prompt user to install it
if (-not $ExchangeOnlineModule) {
    $installExchangeOnline = Read-Host "The 'ExchangeOnlineManagement' module is required but not installed. Do you want to install it now? (Y/N)"
    if ($installExchangeOnline -eq 'Y') {
        Install-Module -Name ExchangeOnlineManagement -Force
        Import-Module ExchangeOnlineManagement
    } else {
        Write-Host "Installation of 'ExchangeOnlineManagement' module skipped. Exiting..."
        exit
    }
}

# If Az.Accounts module is not available, prompt user to install it
if (-not $AzAccountsModule) {
    $installAzAccounts = Read-Host "The 'Az.Accounts' module is required but not installed. Do you want to install it now? (Y/N)"
    if ($installAzAccounts -eq 'Y') {
        Install-Module -Name Az.Accounts -Force
        Import-Module Az.Accounts
    } else {
        Write-Host "Installation of 'Az.Accounts' module skipped. Exiting..."
        exit
    }
}

# All required modules are available, proceed with the script

# Authenticate to Exchange Online and Azure
Write-Host("Now connecting to Exchange Online")
Connect-ExchangeOnline
Write-Host("Now connecting to Azure")
Connect-AzAccount

# Retrieve all applications that have the EWS Full Access permission
$ApplicationsWithEWSPermission = Get-AzADApplication | Where-Object { $_.RequiredResourceAccess.ResourceAccess.Type -eq "Role" -and $_.RequiredResourceAccess.ResourceAccess.Id -eq "dc890d15-9560-4a4c-9b7f-a736ec74ec40" }

# Initialize an empty array to store the results
$results = @()

# Iterate through each application
foreach ($Application in $ApplicationsWithEWSPermission) {
    # Check if there's a corresponding ApplicationAccessPolicy
    $ApplicationAccessPolicy = Get-ApplicationAccessPolicy | Where-Object { $_.AppId -eq $Application.AppId }

    # If ApplicationAccessPolicy exists, list all the members' names and email addresses
    if ($ApplicationAccessPolicy) {
        # Get the members of the group
        $GroupMembers = Get-DistributionGroupMember -Identity $ApplicationAccessPolicy.ScopeName

        # Iterate through each member and output mailbox details
        foreach ($Member in $GroupMembers) {
            $DisplayName = ""
            $EmailAddress = ""
            $GroupName = ""

            # Get the display name, email address, or group name
            if ($Member.RecipientType -eq "UserMailbox") {
                $MailboxDetails = Get-Mailbox -Identity $Member.Identity
                $DisplayName = $MailboxDetails.DisplayName
                $EmailAddress = $MailboxDetails.PrimarySmtpAddress
            } elseif ($Member.RecipientType -eq "MailContact") {
                $MailContactDetails = Get-MailContact -Identity $Member.Identity
                $DisplayName = $MailContactDetails.DisplayName
                $EmailAddress = $MailContactDetails.PrimarySmtpAddress
            } elseif ($Member.RecipientType -eq "GroupMailbox") {
                $GroupName = $Member.Name
            }

            # Add the information to the results array
            $results += [PSCustomObject]@{
                AppName = $Application.DisplayName
                AccessPolicyName = $ApplicationAccessPolicy.ScopeName
                PolicyType = $ApplicationAccessPolicy.AccessRight
                UsernameOrGroupName = if ($GroupName -ne "") { $GroupName } else { $DisplayName }
                MailAddress = $EmailAddress
                Critical = $null
            }
        }
    } else {
        # If no ApplicationAccessPolicy exists, flag it as "critical"
        $results += [PSCustomObject]@{
            AppName = $Application.DisplayName
            AccessPolicyName = "N/A"
            PolicyType = "N/A"
            UsernameOrGroupName = "N/A"
            MailAddress = "N/A"
            Critical = "Yes"
        }
    }
}

# Output the results in a table
$results | Format-Table -AutoSize
