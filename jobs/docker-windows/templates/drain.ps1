$ErrorActionPreference = "Stop";

echo "Querying docker service" | Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"
$docker=(Get-Service | where { $_.Name -eq 'docker' })
if ($docker -eq $null) {
    echo "Docker service not found; Exiting 0" | Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"
    "0"
    Exit 0
}

echo "Docker service found" | Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"
If ($docker.Status -Eq "Running") {
    echo "Docker service running; Stopping" | Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"
    Stop-Service $docker |  Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"
}
echo "Docker service drained; Exit 0" | Out-File -Encoding ASCII -Append "c:\var\vcap\sys\log\docker-windows\drain.log"

"0"
Exit 0
