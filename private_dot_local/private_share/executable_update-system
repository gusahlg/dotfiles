#!/usr/bin/env bash
rm -rf ~/Pictures/Screenshots/*
sudo pacman -Syu --noconfirm
sudo mkinitcpio -P

echo "############################################"
ls /boot/initramfs-linux.img
echo "############################################"
echo "               Update complete!             "
echo "############################################"
read -r -p "Press Enter to close"
exit 0

