#!/bin/bash
# By Nucifer <nucifer666[AT]proton[DOT]me>
# Version 0.1

function check_output() {
  if [ $1 != 0 ];
  then
    echo -e "[ \e[31m\e[40m Error\e[0m ]\n"
    echo -e "\e[1;33m\e[40m[!] Last status code: $1\e[0m"
    exit
  else
    echo -e " [ \e[32mOK\e[0m ]\n"
  fi
}


echo -n -e "[+] Creating symbolic link to localtime"
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
check_output $?
echo -n -e "[*] Adjusting time"
hwclock --systohc
check_output $?

echo -n -e "[+] Adding en_US ISO-8859-1 to locale.gen"
echo "en_US ISO-8859-1" >> /etc/locale.gen
echo -n -e "[+] Running locale-gen"
locale-gen
check_output $?
echo "[+] Adding LANG and KEYMAP to locale.conf and vsconsole.conf"
echo "LANG=en_US ISO-8859-1" >> /etc/locale.conf
echo "KEYMAP=la-latin1" >> /etc/vconsole.conf
echo "[+] Adding hostname 'archifer'"
echo "archifer" >> /etc/hostname
echo -n -e " ! \e[1;35mRunning initramfs\e[0m"
mkinitcpio -P
check_output $?
echo -n -e "[+] Adding new user to the system"
useradd -m nucifer
check_output $?
echo -n -e "\t[+] Added nucifer user"

echo -n -e "[+] Changing default home permissions"
# Directories: U=7, G=5, O=0
# Files: U=6, G=4, O=4
chmod -R a+rwX,o-rw /home
check_output $?