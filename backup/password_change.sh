#!/bin/bash

# Change the password for root
echo "Changing password for root..."
echo "root:Amd123" | sudo chpasswd

# Change the password for amd
echo "Changing password for amd..."
echo "amd:Amd123" | sudo chpasswd

echo "Passwords updated successfully!"
