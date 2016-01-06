#!/bin/sh

sh /support/setHostname.sh $1
mount > /etc/mtab
resize2fs /dev/sda1

mkdir /root_a
mount /dev/sda3 /root_a

mount -t devtmpfs none /root_a/dev
mount -t proc proc /root_a/proc
mount -t sysfs sys /root_a/sys

chroot /root_a sh -c "grub-mkdevicemap"
chroot /root_a sh -c "grub-install /dev/sda3 --force"
chroot /root_a sh -c "update-grub"

mkswap /dev/sda2
echo "/dev/sda3 / ext4 errors=remount-ro 0 1" > /root_a/etc/fstab
echo "/dev/sda5 /home ext4 errors=remount-ro 0 1" >> /root_a/etc/fstab
echo "/dev/sda2 none swap defaults 0 0" >> /root_a/etc/fstab
mount > /etc/mtab

# format the root_b partition
mke2fs -t ext4 /dev/sda4

# Format, mount, and copy the home directory from the primary parition
mkdir /newhome
mke2fs -t ext4 /dev/sda5
mount /dev/sda5 /newhome
cp -ar /root_a/home/* /newhome
rm -rf /root_a/home/*
umount /newhome

# Label all the partitions
#chroot /root_a sh -c "e2label /dev/sda1 recovery"
#chroot /root_a sh -c "e2label /dev/sda6 root_a"
#chroot /root_a sh -c "e2label /dev/sda7 root_b"
#chroot /root_a sh -c "e2label /dev/sda8 home"

#fix the grub debconf selection
chroot /root_a sh -c "echo \"grub-pc grub-pc/install_devices multiselect /dev/sda3\" | debconf-set-selections"

resize2fs /dev/sda3
umount /root_a/dev
umount /root_a/sys
umount /root_a/proc
umount /root_a

