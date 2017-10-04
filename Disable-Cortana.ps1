#requires -Version 3
#Version 1.0
# https://blogs.technet.microsoft.com/secguide/2016/09/23/lgpo-exe-v2-0-pre-release-support-for-mlgpo-and-reg_qword/
# https://technet.microsoft.com/en-us/itpro/windows/manage/waas-restart

# Elevate script if needed
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object -TypeName System.Security.Principal.WindowsPrincipal -ArgumentList ($myWindowsID)
# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running "as Administrator"
}
else
{
    # We are not running "as Administrator" - so relaunch as administrator
    # Create a new process object that starts PowerShell
    $newProcess = New-Object -TypeName System.Diagnostics.ProcessStartInfo -ArgumentList 'PowerShell'
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition
    # Indicate that the process should be elevated
    $newProcess.Verb = 'runas'
    # Start the new process
    $null = [System.Diagnostics.Process]::Start($newProcess)
    # Exit from the current, unelevated, process
    exit
}
# Run your code that needs to be elevated here

Set-Location $PSScriptRoot

<#
        $MachineDir = "$env:windir\system32\GroupPolicy\Machine\registry.pol"
        $UserDir = "$env:windir\system32\GroupPolicy\User\registry.pol"
        #./LGPO.exe /b $PSScriptRoot
        ./LGPO.exe /parse /m $MachineDir | Out-File lgpo.txt 
#>

$LgpoTxt = @"
; ----------------------------------------------------------------------
; PARSING Computer POLICY
; Source file:  C:\WINDOWS\system32\GroupPolicy\Machine\registry.pol

Computer
SOFTWARE\Policies\Microsoft\Windows\Windows Search
AllowCortana
DWORD:0

; PARSING COMPLETED.
; ----------------------------------------------------------------------
"@
$LgpoTxtFile = New-TemporaryFile
$LgpoTxt | Out-File -FilePath $LgpoTxtFile
./LGPO.exe /t $LgpoTxtFile
Remove-Item $LgpoTxtFile

gpupdate.exe /force

'Done'
Pause