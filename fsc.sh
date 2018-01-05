#!/bin/bash
#
# my notes:
#
# example: ./fsc.sh http:\/\/www.google.com
#
HOME_DIR=$HOME
if [ $# -ne 1 ]
then
        echo "usage: $0 <url>"
        exit
else
        url=${1}
        echo "url is: ${url}"
fi

snap() { d=$(date +%m-%d-%y-%H:%M:%S); import -display :1 -window root snap_${d}.png; }
cps3(){
if [ $# -ne 1 ]
then
        echo "usage cps3 filename"
        return
else 
        test -e ${1}
        if [ $? -eq 0 ]
        then  
                echo "copying ${1}"
                #aws s3 cp ${1} s3://empty-1
                gsutil cp ${1} gs://chum
        else 
                echo "not a file"
        fi
fi
}

pid=$(pgrep Xvfb)
if [ $? -ne 0 ]
then
        echo "starting Xvfb"
        /usr/bin/Xvfb :1 -screen 0 1600x1200x24 &
else
        echo "Xvfb allready running"
        echo "killing Xvfb pid: ${pid}"
        kill ${pid}
        echo "starting Xvfb"
        /usr/bin/Xvfb :1 -screen 0 1600x1200x24 &
fi
pid=$(pgrep Xvfb)
sleep 3
xsetroot -display :1 -solid gray
sleep 3
${HOME_DIR}/firefox/firefox --display :1 --new-window ${url} &
sleep 10
#snap
screen_file=screengrab-$(date +%m-%d-%y-%H:%M:%S).png
xte -x :1 "str screenshot ${screen_file} --fullpage" "key Return"
sleep 10
#snap
xte -x :1 "keydown Control_L" "key w" "key Return"
sleep 4
#snap
pkill Xvfb
cps3 ${HOME_DIR}/Downloads/${screen_file}
