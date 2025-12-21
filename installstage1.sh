#!/bin/bash
source /tmp/install-config.env

apt install arch-install-scripts debootstrap

mkfs.ext4 /dev/$rootpart
mount /dev/$rootpart /mnt

debootstrap --arch amd64 stable /mnt https://deb.debian.org/debian 
mount --make-rslave --rbind /proc /mnt/proc 
mount --make-rslave --rbind /sys /mnt/sys 
mount --make-rslave --rbind /dev /mnt/dev 
mount --make-rslave --rbind /run /mnt/run

if [ -d /sys/firmware/efi/efivars/ ]; then
    mkdir /mnt/efi
    echo firmware=uefi >> /tmp/aerios-config.env
    mount /dev/$bootefipart /mnt/efi
else
    echo firmware=bios >> /tmp/aerios-config.env
    mkfs.ext4 /dev/$bootefipart
    mount /dev/$bootefipart /mnt/boot
fi

genfstab -U /mnt >> /mnt/etc/fstab

mkdir /mnt/tmp
cp /tmp/installstage2.sh /mnt/tmp/
cp /tmp/install-config.env /mnt/tmp/

chroot /mnt /tmp/installstage2.sh
