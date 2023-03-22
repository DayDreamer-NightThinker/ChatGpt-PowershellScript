function Start-Mq {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$User,

        [Parameter(Mandatory=$true)]
        [string]$Pw,

        [Parameter(Mandatory=$true)]
        [string]$PrivateRegistry,

        [Parameter()]
        [string]$ImageTag = "docker.io/rabbitmq:3.8.14-management",

        [Parameter(Mandatory=$true)]
        [ValidateScript({ Test-Path $_ -PathType 'Container' })]
        [string]$DataVolume,

        [Parameter()]
        [switch]$Rebuild,

        [Parameter()]
        [switch]$UsePrivateRegistry
    )

    # Check if Docker network "services" exists, if not create it
    $networkExists = docker network ls -q -f name=services
    if (!$networkExists) {
        docker network create services
    }

    # Check if RabbitMQ container is running
    $containerExists = docker ps -q -f name=rabbitmq
    if ($containerExists) {
        if ($Rebuild) {
            docker stop rabbitmq
            docker rm rabbitmq
        } else {
            return
        }
    }

    # Check if RabbitMQ image exists
    $exists = docker images -q $ImageTag
    if ($exists) {
        if ($Rebuild) {
            docker rmi $ImageTag
        } else {
            docker start rabbitmq
            return
        }
    }

    # Build the image name
    if ($UsePrivateRegistry) {
        $imageName = "$PrivateRegistry/$ImageTag"
    } else {
        $imageName = $ImageTag
    }

    # Start the RabbitMQ container
    docker run -d `
        --hostname rabbitmq `
        --name rabbitmq `
        -p 15672:15672 `
        -p 5672:5672 `
        --mount type=bind,src=$DataVolume,dst=/var/lib/rabbitmq `
        --network services `
        $imageName `
        -e RABBITMQ_DEFAULT_USER=$User `
        -e RABBITMQ_DEFAULT_PASS=$Pw
}