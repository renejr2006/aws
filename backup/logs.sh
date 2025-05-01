echo "Checking Logs"

dmesg -T | egrep -ivw default | egrep -i 'bert|mce|mca|error|lockup|fault'
