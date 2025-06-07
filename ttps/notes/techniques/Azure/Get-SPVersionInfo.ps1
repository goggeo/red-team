# Script to check SharePoint version numbers directly with Microsoft
# To use the function, call it like this:
# iex(new-object net.webclient).downloadstring("https://gist.githubusercontent.com/LuemmelSec/208b8ba52b645ec189031d2b5200f76e/raw/c6c1008da1b5670d3fb549578968c2a2f086a00b/Get-SPVersionInfo.ps1")
# Get-SPVersionInfo -ServerUrl "https://my-sharepointserver"
function Get-SPVersionInfo {
    param (
        [string]$ServerUrl,
        [switch]$SkipCertificateCheck,   # Flag to skip certificate checks
        [switch]$SkipHttpErrorCheck      # Flag to skip HTTP error handling
    )

    # Check for PowerShell version compatibility if using Skip flags
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        if ($SkipCertificateCheck -or $SkipHttpErrorCheck) {
            Write-Host "Warning: -SkipCertificateCheck and -SkipHttpErrorCheck are only compatible with PowerShell 7 or higher." -ForegroundColor Yellow
        }
    }

    # Display usage guide if no parameters are provided
    if (-not $ServerUrl -and -not $SkipCertificateCheck -and -not $SkipHttpErrorCheck) {
        Write-Host "Usage: Get-SPVersionInfo -ServerUrl <URL> [-SkipCertificateCheck] [-SkipHttpErrorCheck]" -ForegroundColor DarkYellow
        Write-Host "" -ForegroundColor DarkYellow
        Write-Host "Parameters:" -ForegroundColor DarkYellow
        Write-Host "  -ServerUrl             The URL of the SharePoint server to check." -ForegroundColor DarkYellow
        Write-Host "  -SkipCertificateCheck  (PowerShell 7+) Skips SSL certificate validation errors." -ForegroundColor DarkYellow
        Write-Host "  -SkipHttpErrorCheck    (PowerShell 7+) Allows to skip 401 errors and still fetch the headers." -ForegroundColor DarkYellow
        Write-Host "" -ForegroundColor DarkYellow
        Write-Host "Example:" -ForegroundColor DarkYellow
        Write-Host "  Get-SPVersionInfo -ServerUrl 'https://my-sharepointserver' -SkipCertificateCheck" -ForegroundColor DarkYellow
        return
    }

    # Define the Microsoft update page URL and the service.cnf path
    $msUpdatePage = "https://learn.microsoft.com/en-us/officeupdates/sharepoint-updates"
    $serviceCnfUrl = "$ServerUrl/_vti_pvt/service.cnf"

    # Initialize variables to store both version sources
    $headerVersion = $null
    $serviceCnfVersion = $null

    # Flags to track if matches are found for each version
    $foundMatchHeader = $false
    $foundMatchServiceCnf = $false

    # Fetch the SharePoint headers using GET
    try {
        # Prepare headers for the main request
        $requestParams = @{
            Uri     = $ServerUrl
            Method  = 'Get'
            Headers = @{ "User-Agent" = "Mozilla/5.0" }
            UseBasicParsing = $true
        }

        # Apply certificate and error check overrides based on user input
        if ($SkipCertificateCheck) {
            $requestParams.SkipCertificateCheck = $true
        }
        if ($SkipHttpErrorCheck) {
            $requestParams.SkipHttpErrorCheck = $true
        }

        $response = Invoke-WebRequest @requestParams
        $headerVersion = $response.Headers["MicrosoftSharePointTeamServices"]

        if ($headerVersion) {
            # Normalize header version by removing any unnecessary zeroes
            $headerVersionTrimmed = $headerVersion -replace "(\d+\.\d+)\.0(\.\d+)", '$1$2'
            Write-Host "SharePoint Version from header: $headerVersion"
            Write-Host "Normalized Version from header: $headerVersionTrimmed"
        } else {
            Write-Host "MicrosoftSharePointTeamServices header not found."
        }

        # Fetch version from service.cnf
        $serviceCnfParams = @{
            Uri             = $serviceCnfUrl
            UseBasicParsing = $true
            ErrorAction     = 'Stop'
        }
        if ($SkipCertificateCheck) {
            $serviceCnfParams.SkipCertificateCheck = $true
        }
        if ($SkipHttpErrorCheck) {
            $serviceCnfParams.SkipHttpErrorCheck = $true
        }

        $serviceCnfResponse = Invoke-WebRequest @serviceCnfParams
        if ($serviceCnfResponse -match "vti_extenderversion:SR\|(\d+\.\d+\.\d+\.\d+)") {
            $serviceCnfVersion = $matches[1]
            $serviceCnfVersionTrimmed = $serviceCnfVersion -replace "(\d+\.\d+)\.0(\.\d+)", '$1$2'
            Write-Host "SharePoint Version from service.cnf: $serviceCnfVersion"
            Write-Host "Normalized Version from service.cnf: $serviceCnfVersionTrimmed"
        } else {
            Write-Host "No version information found in service.cnf."
        }

        # Check for mismatch between versions
        if ($headerVersionTrimmed -and $serviceCnfVersionTrimmed) {
            if ($headerVersionTrimmed -ne $serviceCnfVersionTrimmed) {
                Write-Host "`nWarning: Version mismatch detected between header and service.cnf!" -ForegroundColor DarkYellow
                Write-Host "Header Version: $headerVersionTrimmed" -ForegroundColor DarkYellow
                Write-Host "Service.cnf Version: $serviceCnfVersionTrimmed" -ForegroundColor DarkYellow
                Write-Host "Please manually review the versions above to ensure accuracy." -ForegroundColor DarkYellow
            } else {
                Write-Host "`nBoth versions match!" -ForegroundColor Green
                Write-Host "Version: $headerVersionTrimmed" -ForegroundColor Green
            }
        }

        # Fetch MS update page content
        $webContent = Invoke-WebRequest -Uri $msUpdatePage -UseBasicParsing
        $contentText = $webContent.Content

        # Use regex to extract all blocks from <tr> to </tr>
        $trBlocks = [regex]::Matches($contentText, "<tr>(.*?)</tr>", [System.Text.RegularExpressions.RegexOptions]::Singleline)

        # Function to search for a match in MS updates for a given version
        function CheckForMatch {
            param ($versionToCheck, $blocks, [ref]$foundMatch)

            foreach ($block in $blocks) {
                $blockContent = $block.Groups[1].Value

                # Check if the block contains the version we are looking for
                if ($blockContent -match $versionToCheck) {
                    # Extract product, KB number, version, and release date if available
                    $productMatch = [regex]::Match($blockContent, "<td.*?>(.*?)</td>")
                    $kbMatch = [regex]::Match($blockContent, "KB \d+")
                    $versionMatch = [regex]::Match($blockContent, "\d+\.\d+\.\d+\.\d+")
                    $releaseDateMatches = [regex]::Matches($blockContent, "<td.*?>(.*?)</td>")

                    if ($productMatch.Success -and $kbMatch.Success -and $versionMatch.Success -and $releaseDateMatches.Count -gt 0) {
                        $product = $productMatch.Groups[1].Value
                        $kbNumber = $kbMatch.Value
                        $version = $versionMatch.Value
                        $releaseDate = $releaseDateMatches[$releaseDateMatches.Count - 1].Groups[1].Value

                        # Output the results
                        Write-Host "`nMatch Found!"
                        Write-Host "Product: $product"
                        Write-Host "KB Number: $kbNumber"
                        Write-Host "Version: $version"
                        Write-Host "Release Date: $releaseDate"
                        $foundMatch.Value = $true
                        break
                    }
                }
            }
        }

        # Check for matches with both versions if available
        if ($headerVersionTrimmed) {
            Write-Host "`nChecking Microsoft update page for header version..."
            CheckForMatch -versionToCheck $headerVersionTrimmed -blocks $trBlocks -foundMatch ([ref]$foundMatchHeader)
        }

        if ($serviceCnfVersionTrimmed) {
            Write-Host "`nChecking Microsoft update page for service.cnf version..."
            CheckForMatch -versionToCheck $serviceCnfVersionTrimmed -blocks $trBlocks -foundMatch ([ref]$foundMatchServiceCnf)
        }

        # Output if no match was found for either version
        if (-not $foundMatchHeader -and -not $foundMatchServiceCnf) {
            Write-Host "`nNo matching update information found for either version."
        }

    } catch {
        Write-Host "An error occurred: $_"
    }
}
