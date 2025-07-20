#!/bin/bash
clear
set -e
echo "====================="
echo " Run Script v3.0.0"
echo "====================="

backup_restore() {
    sudo bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/backup_restore/script.sh)"
}

ubuntu_desktop() {
    sudo bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/ubuntu_desktop/script.sh)"
}

case "$1" in
    Backup_Restore|backup_restore) backup_restore ;;
    Ubuntu_Desktop|ubuntu_desktop) ubuntu_desktop ;;
    *)
        echo "What do you want to do?"
        select CHOICE in "Backup_Restore" "Ubuntu_Desktop" "Cancel"; do
            case $CHOICE in
                Backup_Restore) backup_restore; break ;;
                Ubuntu_Desktop) ubuntu_desktop; break ;;
                Cancel) echo "Cancelled."; exit 0 ;;
            esac
        done
    ;;
esac
