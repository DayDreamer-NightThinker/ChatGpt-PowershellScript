# Declare global variable called 'services'
$global:services = @()

# Declare a custom object with properties: Folder, ContainerName, Port
function New-ServiceObject ($Folder, $ContainerName, $Port) {
    $obj = [PSCustomObject]@{
        Folder = $Folder
        ContainerName = $ContainerName
        Port = $Port
    }
    return $obj
}

# Create function called 'Set-Services' with a parameter called 'Service'
function Set-Services ([PSCustomObject[]]$Service) {
    if ($Service -ne $null) {
        # Set global variable 'services' as parameter 'Service'
        $global:services = $Service
    }
}

# Example usage
$service1 = New-ServiceObject -Folder "Folder1" -ContainerName "Container1" -Port 8080
$service2 = New-ServiceObject -Folder "Folder2" -ContainerName "Container2" -Port 8081

Set-Services -Service @($service1, $service2)

# Display the content of the 'services' variable
