#!/bin/bash
sudo cp svpn.sh /usr/bin/
sudo mv /usr/bin/svpn.sh /usr/bin/svpn
sudo chmod 777 /usr/bin/svpn
sudo cp -r svpn /opt/
echo 'svpn installation done successfully.'
echo 'run svpn to get help.'