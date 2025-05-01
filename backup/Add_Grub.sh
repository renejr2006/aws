#!/bin/bash

# This script adds parameters to GRUB_CMDLINE_LINUX in the /etc/default/grub file

# Check if we're running as root (needed for making changes)
if [ "$(id -u)" -ne 0 ]; then
  echo "You must run this script as root."
  exit 1
fi

# Backup the original /etc/default/grub file
echo "Backing up original /etc/default/grub..."
cp /etc/default/grub /etc/default/grub.bak

# Check if /etc/default/grub exists
if [ ! -f /etc/default/grub ]; then
  echo "Error: /etc/default/grub file not found."
  exit 1
fi

# The parameters to add to GRUB_CMDLINE_LINUX
GRUB_PARAMS="ras=cec_disable console=tty0 console=ttyS1,115200n8 earlyprintk earlycon=uart8250,io,0x2F8,115200n8"

# Check if the GRUB_CMDLINE_LINUX line exists in the file
if grep -q "^GRUB_CMDLINE_LINUX=" /etc/default/grub; then
  # If it exists, append the new parameters to the existing line
  echo "Appending new parameters to GRUB_CMDLINE_LINUX..."
  sed -i "s/^\(GRUB_CMDLINE_LINUX=\".*\)\"$/\1 $GRUB_PARAMS\"/" /etc/default/grub
else
  # If it doesn't exist, create the GRUB_CMDLINE_LINUX line with the new parameters
  echo "Adding new GRUB_CMDLINE_LINUX line..."
  echo "GRUB_CMDLINE_LINUX=\"$GRUB_PARAMS\"" >> /etc/default/grub
fi

# Regenerate the GRUB configuration to apply changes
echo "Regenerating GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# If using UEFI system, also regenerate the GRUB configuration for EFI
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
fi

# Regenerate GRUB configuration for EFI (this line is added as requested)
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

echo "GRUB configuration updated successfully."
