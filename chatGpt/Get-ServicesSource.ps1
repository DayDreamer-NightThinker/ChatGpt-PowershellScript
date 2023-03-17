function Get-ServicesSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$CodeBaseFolder,
        [Parameter(Mandatory=$false)]
        [string[]]$Include,
        [Parameter(Mandatory=$false)]
        [string[]]$Exclude,
        [Parameter(Mandatory=$false)]
        [Switch]$Pull,
        [Parameter(Mandatory=$false)]
        [Switch]$Checkout
    )

    # Get the CodeBaseFolder path using the Get-CodeBaseFolder function
    $CodeBaseFolder = Get-CodeBaseFolder -BaseFolder $CodeBaseFolder

    # Get the services using the Get-Services function
    $services = Get-Services -Include $Include -Exclude $Exclude

    # For each service, clone the GitHub repository and perform any checkout/pull actions if necessary
    foreach ($service in $services) {
        $repoPath = Join-Path -Path $CodeBaseFolder -ChildPath $service.Name
        $repoUrl = "https://github.com/$($service.Organization)/$($service.Repository).git"

        # If the repository directory does not exist, clone the repository
        if (-not (Test-Path -Path $repoPath -PathType Container)) {
            Write-Verbose "Cloning repository $($service.Repository) to $repoPath"
            git clone $repoUrl $repoPath | Out-Null
        }

        # If the Checkout switch is provided, checkout the specified branch
        if ($Checkout) {
            Write-Verbose "Checking out $($service.Branch) branch for $($service.Repository) in $repoPath"
            git checkout $service.Branch | Out-Null
        }

        # If the Pull switch is provided, pull the latest changes
        if ($Pull) {
            Write-Verbose "Pulling latest changes for $($service.Repository) in $repoPath"
            git pull | Out-Null
        }
    }
}