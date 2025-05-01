echo "Checking if EDAC is present"
lsmod | grep edac

echo "Adding EDAC"
modprobe edac_mce_amd

echo "Checking if EDAC is present"
lsmod | grep edac
