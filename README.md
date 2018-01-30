## svpn ver:0.5 (EN)
svpn help using 'openconnect' easier. specially for VPNMakers users.

### Cloning
you can download this project with download button showed above, or cloning it with this command :
```bash
git clone https://github.com/aasmpro/svpn
```

### Project Content
File | Description
---|---
svpn / svpn.py | this file contains aplication GUI code, writen with **`python 3.6.2`** and **`tkinter`**.
svpn.sh | this bash file handels all svpn abilities.
install.sh | this bash file will be used for installing the svpn program.
uninstall.sh | this bash file will be used for uninstalling the svpn program.

### Installing / Uninstalling
after getting source code, installing it using **`install.sh`** bash file like :
```bash
sudo ./install.sh
```
with the above command, the **`svpn.sh`** bash file will be copied to **`/usr/bin/`** directory as **`svpn`**, so now you can use svpn commands in terminal. also the **`svpn`** directory that contains **`svpn.py`** file will be copied to **`/opt/`** directory.

for Uninstalling the program you can use **`uninstall.sh`** bash file like :
```bash
sudo ./uninstall.sh
```

### Usage
after installing the program, by running **`svpn`** command you will get help for usage.

### Fast Connect!
by editing the **`svpn`** file located at **`/usr/bin/`**, you can set your username, password, server and domain with your own ones.

editting with **`vi`** editor :
```bash
vi /usr/bin/svpn
```
so by doing this, now you can use this command for connecting to vpn server :
```bash
sudo svpn -c
```
