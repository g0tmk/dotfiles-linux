#~/bin/sh

ulimit -c unlimited

/usr/bin/synergyc -f --no-tray --debug INFO --name BXPSd --enable-crypto 10.3.80.146:24800
