# Usage
[!] Pre-partitioning is required.

    Copy all files to /tmp
    Populate 'install-config.env' with your desired values. (See section below!)
    Mark 'installstage1.sh' and 'installstage2.sh' as executable if they aren't already.
    Simply run installstage1.sh and there you go.

# install-config.env
Values:

    username = Your desired username
    password = Your desired password
    hostname = Your desired hostname
    rootpart = Your root partition (e.g insert 'sda2' if your root partition is /dev/sda2)
    bootefipart = Either your boot partition, or EFI System Partition. (e.g 'sda1' if your boot or EFI partition is /dev/sda1)
    disk = Disk name. (e.g 'sda' if your disk is /d
    ev/sda)
