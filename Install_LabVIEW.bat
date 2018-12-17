set Language_=%1
set Year_=%2
set Language_tail_feed=%3

if not exist c:\installers mkdir c:\installers
if not exist c:\installers\log.txt copy NUL c:\installers\log.txt
if not exist "C:\Users\Tester\Desktop\Build.txt" copy NUL "C:\Users\Tester\Desktop\Build.txt"

echo %time%: Connecting to \\cn-sha-argo\ni\nipkg >> log.txt
net use \\cn-sha-argo.natinst.com\ni\nipkg nitest /user:amer\nitest /persistent:no
echo %time%: Connected to \\cn-sha-argo\ni\nipkg >> log.txt

if "%Year_%" == "2018" goto label2018
if "%Year_%" == "2019" goto label2019
goto end

:label2018
FOR /F "tokens=*" %%a in ('dir "\\cn-sha-argo.natinst.com\NISoftwarePrerelease\LabVIEW\%Year_%\%Language_%\Daily" /b /od') do set newest-LV2018=%%a

echo %time%: Installing LV2018 from \\cn-sha-argo.natinst.com\NISoftwarePrerelease\LabVIEW\%Year_%\%Language_%\Daily\%newest-LV2018%\LabVIEW%Year_%\setup.exe >> c:\installers\log.txt

TASKKILL /F /IM NIUpdateService.exe /T
"\\cn-sha-argo.natinst.com\NISoftwarePrerelease\LabVIEW\%Year_%\%Language_%\Daily\%newest-LV2018%\LabVIEW%Year_%\setup.exe" /qb /AcceptLicenses yes /r:n 

echo %time%: Done installing LV2018 from \\cn-sha-argo.natinst.com\NISoftwarePrerelease\LabVIEW\%Year_%\%Language_%\Daily\%newest-LV2018%\LabVIEW%Year_%\setup.exe >> c:\installers\log.txt
echo LV2018 %newest-LV2018% >> "C:\Users\Tester\Desktop\Build.txt"
timeout /t 5
goto end

:label2019
FOR /F "tokens=*" %%a in ('dir "\\cn-sha-argo.natinst.com\ni\nipkg\Package Manager\19.0.0" /b /od') do set newest-packagemanager=%%a
echo %time%: Installing NIPackageManager from \\cn-sha-argo.natinst.com\ni\nipkg\Package Manager\19.0.0\%newest-packagemanager%\install.exe >> log.txt
"\\cn-sha-argo.natinst.com\ni\nipkg\Package Manager\19.0.0\%newest-packagemanager%\install.exe" /Q
cd /d "C:\Program Files\National Instruments\NI Package Manager"
echo %time%: Done installing NIPackageManager from \\cn-sha-argo.natinst.com\ni\nipkg\Package Manager\19.0.0\%newest-packagemanager%\install.exe >> log.txt
echo NIPackageManager %newest-packagemanager% >> c:\installers\installed_software.txt
timeout /t 10
taskkill /f /im NIPackageManager.exe

FOR /F "tokens=*" %%a in ('dir \\cn-sha-argo.natinst.com\ni\nipkg\feeds\ni-l\ni-labview-2019-x86%Language_tail_feed%\19.0.0 /b /od') do set newest-ni-labview-2019=%%a
echo %time%: Installing ni-labview-2019-x86%Language_tail_feed% from http://argohttp.natinst.com/ni/nipkg/feeds/ni-l/ni-labview-2019-x86%Language_tail_feed%/19.0.0/%newest-ni-labview-2019% >> log.txt
nipkg repo-add "http://argohttp.natinst.com/ni/nipkg/feeds/ni-l/ni-labview-2019-x86%Language_tail_feed%/19.0.0/%newest-ni-labview-2019%"
nipkg update

timeout /t 10

start /wait NIPackageManager install "ni-labview-2019-core-x86%Language_tail_feed%" --prevent-reboot --progress-only --accept-eulas
echo %time%: Done installing ni-labview-2019-x86%Language_tail_feed% >> log.txt
echo ni-labview-2019-x86%Language_tail_feed% from http://argohttp.natinst.com/ni/nipkg/feeds/ni-l/ni-labview-2019-x86%Language_tail_feed%/19.0.0/%newest-ni-labview-2019% >> c:\installers\installed_software.txt
timeout /t 10
goto end

:end
rem end
