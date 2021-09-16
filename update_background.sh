#!/bin/bash -x
set -euo pipefail
set +H
#
#
#"/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless -headless --screenshot traffic.png "https://www.google.com/maps/@39.8548773,-95.7839507,5.25z/data=!5m1!1e1"
#/c/Windows/System32/reg.exe add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d C:\Users\s396454\Desktop\backup\torn_flag_3_colors.png /f
#/c/Windows/System32/RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
#
# 1) generate image weather/time/traffic patterns/daily craiglist posting
# 2) send remote commands to browser, and screen shot
# 3) use image magick to build a presentable image
# 4) set background image 
# 5) run this job as a seceduled task

#
# vars:
desktop=/c/Users/s396454/Desktop
imgtool=/c/Users/s396454/Desktop/ImageMagick
winsys=/c/Windows/System32
msys=/c/MinGW/msys/1.0/bin
#firefox=/c/Users/s396454/AppData/Local/Mozilla\ Firefox/firefox.exe
#PATH=/c/Windows/System32:$PATH
#
#"/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless -headless --screenshot traffic.png "https://www.google.com/maps/@39.8548773,-95.7839507,5.25z/data=!5m1!1e1" --window-size=1920,1080
#cd /c/Users/s396454 
#cmd /c upd_bkg.bat
pushd /c/Users/s396454/Desktop
/c/MinGW/msys/1.0/bin/rm -rf raw_weather.png 
/c/MinGW/msys/1.0/bin/rm -rf raw_traffic.png 
/c/MinGW/msys/1.0/bin/rm -rf boottime.png
#"/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless -headless --purgecaches --screenshot raw_weather.png "https://www.google.com/search?&q=weather+in+crofton+md" --window-size=1920,1080
#'/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe' -P headless --screenshot adsfdf.png --window-size=1920,1080 -browser 'http://www.google.com'
"/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless --purgecaches --screenshot raw_weather.png --window-size=1920,1080 -browser "https://www.google.com/search?&q=weather+in+franconia+va"
sleep 5
"/c/Users/s396454/AppData/Local/Mozilla Firefox/firefox.exe" -P headless --purgecaches --screenshot raw_traffic.png --window-size=1920,1080 -browser "https://www.google.com/maps/@38.8917003,-77.0130833,11.5z/data=!5m1!1e1"
# maybe this should be shrunk a little bit...
#$imgtool/convert.exe raw_weather.png -crop 653x471+180+170 cr_weather.png
$imgtool/convert.exe raw_weather.png -crop 663x363+180+170 cr_weather.png
#$winsys/systeminfo.exe  | $msys/grep "System Boot" | $imgtool/convert label:@- boottime.png
btime=$( $winsys/systeminfo | $msys/grep "Boot Time" )
$msys/echo -e "$btime \n last update: $($msys/date)" | $imgtool/convert label:@- boottime.png
$imgtool/composite -watermark 30% raw_traffic.png temp_bg.png temp_bg.png
$imgtool/composite  -geometry +1221+8 cr_weather.png temp_bg.png temp_bg.png
$imgtool/composite  -geometry +1666+1018 boottime.png temp_bg.png temp_bg.png
popd

for i in 1 2 3 4
do
	/c/Windows/System32/rundll32 user32.dll,UpdatePerUserSystemParameters
	$msys/sleep 1
	/c/Windows/System32/rundll32 user32.dll,UpdatePerUserSystemParameters 1 True
	$msys/sleep 1
	/c/Windows/System32/rundll32 user32.dll,UpdatePerUserSystemParameters 1 False
	$msys/sleep 1
done
/c/Windows/System32/taskkill.exe "//fi" "IMAGENAME eq explorer.exe"
