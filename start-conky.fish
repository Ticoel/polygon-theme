#!/usr/bin/fish

sleep 1

killall -SIGTERM conky

cd $HOME/Theme/conky-s-polygon-theme/

cd ./polygon-conky
conky --daemonize --pause=1 --config=polygon-conky.conf

cd ../other-conky
conky --daemonize --pause=1 --config=other-conky.conf

exit