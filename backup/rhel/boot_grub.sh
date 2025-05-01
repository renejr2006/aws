#!/bin/bash

# This script sets GRUB_TIMEOUT to 0 to disable the GRUB menu and enable automatic boot

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

# Set GRUB timeout to 0 for automatic boot without a selection screen
echo "Setting GRUB_TIMEOUT to 0 for automatic boot..."
sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=0/' /etc/default/grub

# Regenerate the GRUB configuration to apply changes
echo "Regenerating GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# If using UEFI system, also regenerate the GRUB configuration for EFI
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
fi

echo "GRUB_TIMEOUT has been set to 0, and GRUB configuration has been updated successfully."
