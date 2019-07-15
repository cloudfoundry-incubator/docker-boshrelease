$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$mtx = New-Object System.Threading.Mutex($false, "PathMutex")

if (!$mtx.WaitOne(300000)) {
  throw "Could not acquire PATH mutex"
}

$AddedFolder= "C:\var\vcap\packages\docker-windows\docker\"

$OldPath=(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path

if (-not $OldPath.Contains($AddedFolder)) {
  $NewPath=$OldPath+';'+$AddedFolder
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
}

$mtx.ReleaseMutex()

powershell $PSScriptRoot\daemon-config.ps1

$docker=(Get-Service | where { $_.Name -eq 'docker' })
if ($docker -eq $null) {
  C:\var\vcap\packages\docker-windows\docker\dockerd --register-service
}

Start-Service Docker
