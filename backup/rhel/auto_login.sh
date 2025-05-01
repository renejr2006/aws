#!/bin/bash

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

# Restart GDM to apply changes (this will cause a graphical session restart)
echo "Restarting GDM to apply changes..."
systemctl restart gdm
