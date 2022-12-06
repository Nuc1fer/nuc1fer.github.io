#!/bin/bash
# By Nucifer <nucifer666[AT]proton[DOT]me>
# Version 0.1
echo -n -e"[+] Archifer 0.1 installation, by Nucifer.\n"
read -p "[?] Are the partitionsd mounted? y/n ", system_mounted
read -p "[?] Is this a VM Arch linux?", is_vm

function check_output(code) {
  if [ code != 0 ];
  then
    echo -e "[ \e[31m\e[40m Error\e[0m ]\n"
    echo -e "\e[1;33m\e[40m[!] Last status code: $code\e[0m"
    exit
  else
    echo -e " [ \e[33mOK\e[0m ]\n"
  fi
}

if [ is_vm = "y" ] || [ is_vm = "Y"];
then
  declare -r preinstall_packages="https://nuc1fer.github.io/preinstall-vm-packages.txt"
else
  declare -r preinstall_packages="https://nuc1fer.github.io/preinstall-packages.txt"
fi

if [ system_mounted = "y" ] || [ system_mounted = "Y" ];
then
  echo -n -e" [+] Beginning system installation on /mnt"
  echo -n -e" [+] Gather the packages with cURL"
  curl $preinstall_packages > packages.txt
  check_output($?)
  echo -n -e "[+] Run pacstrap"
  pacstrap -K /mnt - < packages.txt
  check_output($?)
  echo -n -e" [+] Finished intalling the system to /mnt, generating static file system information (genfstab)"
  genfstab -U /mnt >> /mnt/etc/fstab
  check_output($?)
  echo -n -e" [+] Finished genfstab, running arch-chroot"
  arch-chroot /mnt
  check_output($?)

  # Directories: U=7, G=5, O=0
  # Files: U=6, G=4, O=4
  echo -n -e "[+] Creating symbolic link to localtime"
  ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
  check_output($?)
  echo -n -e "[*] Adjusting time"
  hwclock --systohc
  check_output($?)
  
  echo -n -e "[+] Adding en_US ISO-8859-1 to locale.gen"
  echo "en_US ISO-8859-1" >> /etc/locale.gen
  echo -n -e "[+] Running locale-gen"
  locale-gen
  check_output($?)
  echo "[+] Adding LANG and KEYMAP to locale.conf and vsconsole.conf"
  echo "LANG=en_US ISO-8859-1" >> /etc/locale.conf
  echo "KEYMAP=la-latin1" >> /etc/vconsole.conf
  echo "[+] Adding hostname 'archifer'"
  echo "archifer" >> /etc/hostname
  echo -n -e " ! \e[1;33mRunning initramfs\e[0m"
  mkinitcpio -P
  check_output($?)
  echo -n -e "[+] Adding new user to the system"
  useradd -m nucifer
  check_output($?)
  echo -n -e "\t[+] Added nucifer user"
  
  echo -n -e "[+] Changing default home permissions"
  chmod -R a+rwX,o-rw /home
  check_output($?)
else
  echo -n -e "[!] Program will end immediately, as partitions are not mounted"
  exit 1
