#!/usr/bin/fish

printf "Starting..."

sleep 1

killall -SIGTERM conky

cd /home/nicolas/Theme/pentagone-conky/

conky --daemonize --pause=1 --config=conkyrc

printf "Started!"