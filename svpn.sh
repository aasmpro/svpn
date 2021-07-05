#!/bin/bash
version=0.6
job=h

account=''
server=''
username=''
password=''

function config_read_file() {
  (grep -E "^${2}=" -m 1 "${1}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-
}

function config_get() {
  if [[ -f $1 ]]; then
    val="$(config_read_file "${1}" "${2}")"
  else
    val="$(config_read_file ~/.svpn/"${1}" "${2}")"
  fi
  echo "$val"
}

function connect() {
  if [ -n "$account" ]; then
    server="$(config_get $account server)"
    username="$(config_get $account username)"
    password="$(config_get $account password)"
  fi
  sudo openconnect -b $server -u $username --passwd-on-stdin <<ENDDOC
$password
yes
ENDDOC
}

function disconnect() {
  sudo killall openconnect
}

function help() {
  echo ""
  echo "an openconnect wrapper. version $version"
  echo ""
  echo "  abilities: "
  echo "      -c      connecting server using server/username/password from config"
  echo "      -d      disconnecting server"
  echo ""
  echo "  options: "
  echo "      -a      account config file path"
  echo "              default directory is ~/.svpn"
  echo "      -s      server"
  echo "      -u      username"
  echo "      -p      password"
  echo ""
  echo "  sample config file: "
  echo "      server=server.domain.com"
  echo "      username=your_user"
  echo "      password=your_pass"
  echo ""
  echo "report bugs to https://github.com/aasmpro/svpn/issues"
  echo ""
}

while getopts ":a:s:u:p: :c :d :h" opt; do
  case $opt in
  a)
    account="$OPTARG" >&2
    ;;
  s)
    server="$OPTARG" >&2
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
h)
  help
  ;;
esac
