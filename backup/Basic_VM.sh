#!/bin/bash

echo "Setting UP Autologin"
# This script enables auto-login for the root user in GDM (GNOME Display Manager)
# Check if we're running as root (needed for making changes)
if [ "$(id -u)" -ne 0 ]; then
  echo "You must run this script as root."
  exit 1
fi

# Backup the original GDM configuration file
echo "Backing up original /etc/gdm/custom.conf..."
cp /etc/gdm/custom.conf /etc/gdm/custom.conf.bak

# Check if /etc/gdm/custom.conf exists
if [ ! -f /etc/gdm/custom.conf ]; then
  echo "Error: /etc/gdm/custom.conf file not found."
  exit 1
fi

# Modify the GDM configuration to enable auto-login for root

# Check if [daemon] section exists
if grep -q "^\[daemon\]" /etc/gdm/custom.conf; then
  echo "[daemon] section found, adding auto-login settings."
else
  echo "Error: [daemon] section not found. Please check the file manually."
  exit 1
fi

# Add lines to enable automatic login for root under the [daemon] section
sed -i '/^\[daemon\]/a \
# Enabling automatic login for the root user\n\
AutomaticLoginEnable = true\n\
AutomaticLogin = root' /etc/gdm/custom.conf

# Verify the changes
echo "Verifying changes to /etc/gdm/custom.conf..."

# Check if the settings were added correctly
if grep -q "AutomaticLoginEnable = true" /etc/gdm/custom.conf && grep -q "AutomaticLogin = root" /etc/gdm/custom.conf; then
  echo "Auto-login for root has been successfully enabled."
else
  echo "Failed to modify GDM configuration. Please check the file manually."
  exit 1
fi

# Change the password for root
echo "Changing password for root..."
echo "root:Amd123" | sudo chpasswd

# Change the password for amd
echo "Changing password for amd..."
echo "amd:Amd123" | sudo chpasswd

echo "Passwords updated successfully!"

echo "Changing Timezone to America/Chicago (CST)"
timedatectl set-timezone America/Chicago
echo "Timezone Change to America/Chicago (CST)"

echo "Registering System"
subscription-manager register --username amd64 --password opteron --auto-attach

echo "Adding bootgrub timer to 0"
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

echo "Checking for available Updates"
sudo yum check-update

echo "Updating Packages"
sudo yum update -y

echo "System Update Completed"

sleep 30

# Restart GDM to apply changes (this will cause a graphical session restart)
echo "Restarting GDM to apply changes..."
systemctl restart gdm
