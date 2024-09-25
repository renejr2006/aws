$moduleName = "PSWindowsUpdate"
$logfile = Join-Path -Path $PSScriptRoot -ChildPath "System_Updates.log"

if (-not (Get-Module -ListAvailable -name $moduleName)) {
    Write-Output "Installing $moduleName module..."
    Install-Module -Name $moduleName -Scope CurrentUser -Force -Confirm:$false | Tee-Object -filePath $logfile -Append
} else {
    Write-Output "moduleName module is already installed." | Tee-Object -filePath $logfile -Append
}

Import-Module -Name $moduleName -Force | Tee-Object -filePath $logfile -Append

Write-Output "$moduleName module has been imported." | Tee-Object -filePath $logfile -Append

Get-WindowsUpdate | Tee-Object -filePath $logfile -Append
Get-WindowsUpdate -AcceptAll -Install | Tee-Object -filePath $logfile -Append
Get-WindowsUpdate | Tee-Object -filePath $logfile -Append
