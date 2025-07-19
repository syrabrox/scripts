#!/bin/bash
set -e

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

if [ -e "$LOCKFILE" ]; then
    echo "❗ A backup or restore process is already running (Lockfile: $LOCKFILE)"
    exit 1
fi

touch "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

backup() {
    START_TIME=$(date +%s)
    echo "Backup started: $(date)"

    DEST_DIR="$BACKUP_DIR/$DATE"
    sudo mkdir -p "$DEST_DIR"

    PATHS=("/home/asa/test")

    for PATH in "${PATHS[@]}"; do
        BASENAME=$(basename "$PATH")
        ARCHIVE="$DEST_DIR/${BASENAME//\//-}-$DATE.tar.gz"
        echo "Backing up ($PATH) to $ARCHIVE"
        sudo tar --xattrs --xattrs-include='*' --acls --selinux --numeric-owner -czpvf "$ARCHIVE" "$PATH"
    done

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo "✅ Backup finished at $(date)"
    echo "⏳ Duration: ${DURATION} seconds"

    send_webhook "📦 **Backup completed!**\nServer: \`$(hostname)\`\nDuration: \`${DURATION}\` seconds\nTime: \`$(date)\`"
}

restore() {
    read -p "Enter full path to the backup file (.tar.gz): " BACKUP_FILE
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "❌ File not found: $BACKUP_FILE"
        exit 1
    fi

    START_TIME=$(date +%s)
    echo "Restore started: $(date)"

    echo "Restoring from $BACKUP_FILE"
    sudo tar --xattrs --xattrs-include='*' --acls --selinux --numeric-owner -xzpvf "$BACKUP_FILE" -C /

    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo "✅ Restore completed at $(date)"
    echo "⏳ Duration: ${DURATION} seconds"
    
    sudo systemctl stop docker
    sudo systemctl start docker
    docker update --restart unless-stopped $(docker ps -q)

    send_webhook "♻️ **Restore completed!**\nServer: \`$(hostname)\`\nDuration: \`${DURATION}\` seconds\nTime: \`$(date)\`"
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
