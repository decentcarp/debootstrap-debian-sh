#!/bin/bash
source /tmp/install-config.env

DEBIAN_FRONTEND=noninteractive

cat > /etc/apt/sources.list << HEREDOC
deb https://deb.debian.org/debian/ trixie main contrib non-free-firmware 
deb-src https://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware 
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware 
deb-src https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware 
deb https://deb.debian.org/debian/ trixie-updates main contrib non-free-firmware 
deb-src https://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware 
HEREDOC

apt update
apt install apt-utils dialog
apt install locales console-setup

dpkg-reconfigure --frontend dialog locales

ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

apt install network-manager
apt install sudo

echo $hostname > /etc/hostname
echo 127.0.0.1 $hostname >> /etc/hosts

useradd -m -G users,sudo,audio,video -s /bin/bash $username
echo "$username":"$password" | chpasswd

# Linux
apt install linux-image-amd64 firmware-linux

# XFCE
apt install libxfce4ui-utils thunar xfce4-appfinder xfce4-panel xfce4-session xfce4-settings xfdesktop4 xfwm4 xfce4-terminal xfce4-screenshooter mousepad ristretto xfce4-screensaver

# Firefox ESR, MATE's Document Viewer
apt install firefox-esr atril 

# Misc
apt install curl bzip2 git make libsdl3-dev clang

# LightDM
apt install lightdm 
apt install slick-greeter
dpkg-reconfigure lightdm
systemctl enable lightdm
cat > /etc/lightdm/lightdm.conf << CONFIGHERE
[LightDM]

[Seat:*]
greeter-session=slick-greeter
greeter-hide-users=false

[XDMCPServer]

[VNCServer]
CONFIGHERE

rm -rf /etc/lightdm/lightdm-gtk-greeter.conf
touch /etc/lightdm/slick-greeter.conf
cat > /etc/lightdm/slick-greeter.conf << IMRUNNINGOUTOFSHIT
[greeter]

IMRUNNINGOUTOFSHIT

if [ "$firmware" == "uefi" ]; then
  apt install grub-efi
  grub-install --efi-directory=/efi
  grub-mkconfig -o /boot/grub/grub.cfg
else
  apt install grub2
  grub-install /dev/$disk
  grub-mkconfig -o /boot/grub/grub.cfg
fi
