#!/bin/bash -x
set -euo pipefail
set +H
#
#
#"/mnt/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless -headless --screenshot traffic.png "https://www.google.com/maps/@39.8548773,-95.7839507,5.25z/data=!5m1!1e1"
#/mnt/c/Windows/System32/reg.exe add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d C:\Users\s396454\Desktop\backup\torn_flag_3_colors.png /f
#/mnt/c/Windows/System32/RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
#
# 1) generate image weather/time/traffic patterns/daily craiglist posting
# 2) send remote commands to browser, and screen shot
# 3) use image magick to build a presentable image
# 4) set background image 
# 5) run this job as a seceduled task

#
# vars:
export PATH=/home/nelliott/bin:/home/nelliott/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:"/mnt/mnt/c/Program Files/WindowsApps/CanonicalGroupLimited.Ubuntu16.04onWindows_1604.2019.523.0_x64__79rhkp1fndgsc":/mnt/mnt/c/WINDOWS/system32:/mnt/mnt/c/WINDOWS:/mnt/mnt/c/WINDOWS/System32/Wbem:/mnt/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/mnt/c/WINDOWS/System32/OpenSSH/:"/mnt/mnt/c/Program Files (x86)/Sennheiser/SenncomSDK/":/mnt/mnt/c/Users/s396454/AppData/Local/Microsoft/WindowsApps:/snap/bin
desktop=/mnt/c/Users/s396454/Desktop
imgtool=/mnt/c/Users/s396454/Desktop/ImageMagick
winsys="/mnt/c/Windows/System32"
firefox=/mnt/c/Users/s396454/Desktop/firefox_screenshot/firefox.exe
pushd /mnt/c/Users/s396454/Desktop
/bin/rm -rf raw_weather.png 
/bin/rm -rf raw_traffic.png 
/bin/rm -rf boottime.png
$firefox -P garbage --purgecaches --screenshot raw_weather.png --window-size=1920,1080 -browser "https://www.google.com/search?&q=weather+in+Newington+va"
/bin/sleep 5
$firefox -P garbage --screenshot raw_traffic.png --window-size=1920,1080 -browser "https://www.google.com/maps/@38.8917003,-77.0130833,11.5z/data=!5m1!1e1"
/bin/sleep 5
# maybe this should be shrunk a little bit...
#$imgtool/mnt/convert.exe raw_weather.png -crop 653x471+180+170 cr_weather.png
$imgtool/convert.exe raw_weather.png -crop 663x363+180+170 cr_weather.png
#$winsys/systeminfo.exe  | /bin/grep "System Boot" | $imgtool/convert.exe label:@- boottime.png
btime=$( $winsys/systeminfo.exe | /bin/grep "Boot Time" | /usr/bin/awk '{$1=$1;print}')
/bin/echo -e "$btime\nlast update: $(/bin/date)" | $imgtool/convert.exe label:@- boottime.png
$imgtool/composite.exe -watermark 50% raw_traffic.png base.png bg.png
$imgtool/composite.exe  -geometry +1221+8 cr_weather.png bg.png bg.png
$imgtool/composite.exe  -geometry +1649+1002 boottime.png bg.png bg.png
popd

for i in 1 2 3 4
do
	/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters
	/bin/sleep 1
	/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters 1 True
	/bin/sleep 1
	/mnt/c/Windows/System32/rundll32.exe user32.dll,UpdatePerUserSystemParameters 1 False
	/bin/sleep 1
done
$winsys/taskkill.exe "/fi" "IMAGENAME eq explorer.exe"
