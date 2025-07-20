#!/bin/bash
clear
set -e
echo "==============================="
echo " Backup/Restore Script v2.0.4"
echo "==============================="
LOCKFILE="/tmp/backup.lock"
BACKUP_DIR="/backup"
WEBHOOK_FILE="$BACKUP_DIR/webhook.txt"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')

if [ -f "$WEBHOOK_FILE" ]; then
    WEBHOOK_URL=$(cat "$WEBHOOK_FILE")
fi

if [ -z "$WEBHOOK_URL" ]; then
    read -p "Please enter your Discord Webhook URL: " WEBHOOK_URL
    echo "$WEBHOOK_URL" > "$WEBHOOK_FILE"
fi

send_webhook() {
    local MESSAGE=$1
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"${MESSAGE}\"}" \
         "$WEBHOOK_URL"
}

backup() {
    if [ -e "$LOCKFILE" ]; then
        echo "❗ A backup or restore process is already running (Lockfile: $LOCKFILE)"
        exit 1
    fi
    if [ -n "$(sudo docker ps -q)" ]; then
        sudo docker stop $(docker ps -q)
    fi
    send_webhook "📦 **Backup Started!**\nServer: \`$(hostname)\`\nTime: \`$(date)\`"
    touch "$LOCKFILE"
    START_TIME=$(date +%s)
    echo "Backup started: $(date)"

    DEST_DIR="$BACKUP_DIR/$DATE"
    sudo mkdir -p "$DEST_DIR"

    PATHS=(
        "/var/lib/docker/"
        "/home/asa/"
        "/media/"
    )

    for path in "${PATHS[@]}"; do
        if [ -e "$path" ]; then
            safe_name=$(echo "$path" | sed 's|/|-|g' | sed 's/^-*//')
            echo "Backing up $path to $DEST_DIR/${safe_name}-$DATE.tar.gz"
            sudo tar --xattrs --xattrs-include='*' --acls --selinux --numeric-owner -czpvf "$DEST_DIR/${safe_name}-$DATE.tar.gz" "$path"
        else
            echo "Warning: Path $path does not exist, skipping."
        fi
    done

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo "✅ Backup finished at $(date)"
    echo "⏳ Duration: ${DURATION} seconds"

    send_webhook "📦 **Backup completed!**\nServer: \`$(hostname)\`\nDuration: \`${DURATION}\` seconds\nTime: \`$(date)\`"
    rm -f "$LOCKFILE"
    if [ -n "$(sudo docker ps -aq)" ]; then
        sudo docker start $(docker ps -aq)
    fi
}

restore() {
    send_webhook "📦 **Restore Started!**\nServer: \`$(hostname)\`\nTime: \`$(date)\`"
    echo "Choose restore mode:"
    echo "1) Manual (enter full path to .tar.gz file)"
    echo "2) Automatic (select folder in $BACKUP_DIR to restore all .tar.gz files)"
    read -rp "Enter choice (1 or 2): " MODE

    if [ "$MODE" == "1" ]; then
        read -rp "Enter full path to the backup file (.tar.gz): " BACKUP_FILE
        if [ ! -f "$BACKUP_FILE" ]; then
            echo "❌ File not found: $BACKUP_FILE"
            exit 1
        fi
        restore_tar "$BACKUP_FILE"

    elif [ "$MODE" == "2" ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            echo "❌ Backup directory not found: $BACKUP_DIR"
            exit 1
        fi

        echo "Available backup folders:"
        mapfile -t FOLDERS < <(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
        if [ ${#FOLDERS[@]} -eq 0 ]; then
            echo "❌ No backup folders found in $BACKUP_DIR"
            exit 1
        fi

        for i in "${!FOLDERS[@]}"; do
            echo "$((i+1)). $(basename "${FOLDERS[i]}")"
        done

        read -rp "Select folder number to restore: " FOLDER_CHOICE
        if ! [[ "$FOLDER_CHOICE" =~ ^[0-9]+$ ]] || ((FOLDER_CHOICE < 1)) || ((FOLDER_CHOICE > ${#FOLDERS[@]})); then
            echo "❌ Invalid selection"
            exit 1
        fi

        SELECTED_FOLDER="${FOLDERS[$((FOLDER_CHOICE-1))]}"
        echo "Selected folder: $SELECTED_FOLDER"

        mapfile -t TARFILES < <(find "$SELECTED_FOLDER" -maxdepth 1 -type f -name '*.tar.gz' | sort)
        if [ ${#TARFILES[@]} -eq 0 ]; then
            echo "❌ No .tar.gz files found in $SELECTED_FOLDER"
            exit 1
        fi

        for tarfile in "${TARFILES[@]}"; do
            echo "Restoring $tarfile ..."
            restore_tar "$tarfile"
        done

    else
        echo "❌ Invalid mode selected."
        exit 1
    fi

    sudo systemctl stop docker
    sudo systemctl start docker
    docker update --restart unless-stopped $(docker ps -q)

    send_webhook "♻️ **Restore completed!**\nServer: \`$(hostname)\`\nTime: \`$(date)\`"
}

restore_tar() {
    local BACKUP_FILE="$1"
    START_TIME=$(date +%s)
    echo "Restore started: $(date)"
    echo "Restoring from $BACKUP_FILE"
    sudo tar --xattrs --xattrs-include='*' --acls --selinux --numeric-owner -xzpvf "$BACKUP_FILE" -C /
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    echo "✅ Restore completed at $(date)"
    echo "⏳ Duration: ${DURATION} seconds"
}

case "$1" in
    Backup|backup) backup ;;
    Restore|restore) restore ;;
    *)
        echo "What do you want to do?"
        select CHOICE in "Backup" "Restore" "Cancel"; do
            case $CHOICE in
                Backup) backup; break ;;
                Restore) restore; break ;;
                Cancel) echo "Cancelled."; exit 0 ;;
            esac
        done
    ;;
esac
