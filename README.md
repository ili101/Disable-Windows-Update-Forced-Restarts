# Disable Windows Update Forced Restarts
This script uses LGPO.exe
https://blogs.technet.microsoft.com/secguide/2016/09/23/lgpo-exe-v2-0-pre-release-support-for-mlgpo-and-reg_qword/
To set Local GPO Option "No auto-restart with logged on users for scheduled automatic updates installations"
https://technet.microsoft.com/en-us/itpro/windows/manage/waas-restart
To stop Windows from automatically restarting after installing updates if a user is logged on

### How to use
Download https://github.com/ili101/Disable-Windows-Update-Forced-Restarts/archive/master.zip<br>
Extract the zip<br>
Left click DWUFR.ps1 and select "Run with Powershell"