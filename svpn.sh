#!/bin/bash

server=uk
domain=cisadd2.com

username=''
password=''

job=h
version=0.5

function connect {
modprobe tun
openconnect -b $server.$domain -u $username --passwd-on-stdin <<ENDDOC
$password
yes
ENDDOC
}

function disconnect {
pkill -SIGINT openconnect > /dev/null
}

function gui {
python3 /opt/svpn/svpn.py
}

function help {
    echo ""
    echo "version : $version"
    echo "svpn help using 'openconnect' easier."
    echo "you can edit this bash file and replace username, password, server and domain with your own ones, so easily connect / disconnect server with just a command. file is located at /usr/bin/svpn."
    echo ""
    echo "  attentions : "
    echo "       1. there is no order for options or abilities! feel free!"
    echo "       2. except -g (for GUI), other commands must run with sudo (as root)."
    echo ""
    echo "  abilities : "
    echo "      -c      connecting server using username/password in file, or specified by user."
    echo "      -d      disconnecting server."
    echo "      -g      lunching GUI."
    echo "              GUI had been developed with Python 3.6.3 and tkinter. this option will run 'python3 /opt/svpn/svpn.py' command."
    echo "              attention that running this command with sudo will cause getting error."
    echo ""
    echo "  options : "
    echo "      -s      server address."
    echo "      -n      server domain."
    echo "      -u      username."
    echo "      -p      password."
    echo ""
    echo "report bugs to https://github.com/aasmpro/svpn/issues"
    echo "or aasmpro@gmail.com with 'svpn' in subject."
    echo ""
}


while getopts ":s:n:u:p: :c :d :g :h" opt; do
  case $opt in
    s)
		server="$OPTARG" >&2
      ;;
    n)
		domain="$OPTARG" >&2
      ;;
    u)
		username="$OPTARG" >&2
      ;;
    p)
		password="$OPTARG" >&2
      ;;
    c)
		job="c" >&2
      ;;
    d)
		job="d" >&2
      ;;
    g)
		job="g" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

case $job in
	c)
		connect
	;;
	d)
		disconnect
	;;
	g)
		gui
	;;
	h)
	    help
	;;
esac
