#!/bin/bash
# By Nucifer <nucifer666[AT]proton[DOT]me>
# Version 0.1
echo -n -e "[+] Archifer 0.1 installation, by \e[1;36mNucifer.\e[0m\n"
read -p "[?] Are the partitionsd mounted? y/n ", system_mounted
read -p "[?] Is this a VM Arch linux?", is_vm

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

if [ "$is_vm" = "y" ] || [ "$is_vm" = "Y" ];
then
  declare -r preinstall_packages="https://nuc1fer.github.io/preinstall-vm-packages.txt"
else
  declare -r preinstall_packages="https://nuc1fer.github.io/preinstall-packages.txt"
fi

if [ "$system_mounted" = "y" ] || [ "$system_mounted" = "Y" ];
then
  echo -n -e " [+] Beginning system installation on /mnt"
  echo -n -e " [+] Gather the packages with cURL"
  curl $preinstall_packages > packages.txt
  check_output $?
  echo -n -e " [+] Run pacstrap"
  pacstrap -K /mnt - < packages.txt
  check_output $?
  echo -n -e " [+] Finished intalling the system to /mnt, generating static file system information (genfstab)"
  genfstab -U /mnt >> /mnt/etc/fstab
  check_output $?
  echo " [+] Finished genfstab, running arch-chroot, this script will end when arch-chroot exits."
  echo -n -e "   [?] Inside chroot run \"\e[1;34mcurl \e[1;32mhttps://nuc1fer.github.io/postinstall-live.sh\e[1;37m > postinstall-live.sh\e[0m\""
  arch-chroot /mnt
  echo -n -e " [+] Program will now exit."
else
  echo -n -e "[!] Program will end immediately, as partitions are not mounted"
  exit 1
