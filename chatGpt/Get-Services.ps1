function Get-Services {
    param (
        [Parameter(Mandatory=$false)]
        [string[]]$Include,
        [Parameter(Mandatory=$false)]
        [string[]]$Exclude
    )

    # Declare an array variable to hold the matching services
    $retSrvs = @()

    # If Include parameter is not provided, use the global variable called "services"
    if (-not $Include) {
        $Include = $global:services
       }
    else 
    {
    # Iterate through each item in Include and check whether it matches any service folder
    # ** foreach ($item in $Include) { ## change to use powershell
       $Include| Foreach-Object {
           $item = $_
           $found = $global:services | Where-Object { $_.Folder -eq $item }
   
           if !($found) {
               Write-Verbose "No match found for: $item"
           } else {
               $retSrvs += $found
           }
       }
    }

    # Iterate through each item in Exclude and remove it from the retSrvs array
    # ** foreach ($item in $Exclude) { ## change to use powershell
    
    $Exclude| Foreach-Object {
        $item = $_
        if (-not ($retSrvs | Where-Object { $_.Folder -eq $item })) {
            Write-Verbose "No match found for exclusion: $item"
        } else {
            $retSrvs = $retSrvs | Where-Object { $_.Folder -ne $item }
        }
    }

    # If there are no matching services, log an error and return an empty array
    if (-not $retSrvs) {
        Write-Error "No services match"
        return @()
    }

    # Return the matching services
    return $retSrvs
}