function Get-CodeBaseFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$BaseFolder = $env:CodeBaseFolder
    )
    
    # If no BaseFolder parameter is specified, use the environment variable CodeBaseFolder
    if (-not $BaseFolder) {
        $BaseFolder = $env:CodeBaseFolder
    }
    
    # Check if the folder exists; if not, create it and log the action
    if (-not (Test-Path -Path $BaseFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $BaseFolder | Out-Null
        Write-Verbose "Created folder: $BaseFolder"
    }
    
    # Return the folder path
    return $BaseFolder
}