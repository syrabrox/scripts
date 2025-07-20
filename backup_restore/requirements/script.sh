#!/bin/bash

REMOTE_URL="https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/backup_restore/requirements/script.py"

check_python() {
    command -v python3 >/dev/null 2>&1 || {
        echo "Python3 is NOT installed. Installing..."
        sudo apt update && sudo apt install -y python3 || { echo "ERROR: Failed to install Python3."; exit 1; }
    }
    echo "Python3 is installed."
}

check_flask() {
    python3 -c "import flask" >/dev/null 2>&1 || {
        echo "Flask is NOT installed. Installing python3-flask..."
        sudo apt update && sudo apt install -y python3-flask || { echo "ERROR: Failed to install Flask."; exit 1; }
    }
    echo "Flask is installed."
}

enable_redirect() {
    sudo iptables -t nat -A PREROUTING -p tcp --dport 1:65535 -j REDIRECT --to-port 80
    echo "All traffic redirected to port 80."
}

disable_redirect() {
    sudo iptables -t nat -D PREROUTING -p tcp --dport 1:65535 -j REDIRECT --to-port 80
    echo "Redirect to port 80 disabled."
}

start_server() {
    check_python
    check_flask
    enable_redirect

    TMP_SCRIPT="/tmp/serve.py"
    curl -sS -H 'Cache-Control: no-cache' "$REMOTE_URL" -o "$TMP_SCRIPT"

    nohup python3 "$TMP_SCRIPT" > /dev/null 2>&1 &

    echo "Server started with PID $!."
}

stop_server() {
    disable_redirect
    PID=$(pgrep -f "python3.*serve.py" | head -n 1)
    if [ -z "$PID" ]; then
        echo "No running server found."
    else
        kill "$PID"
        echo "Server with PID $PID stopped."
    fi
}

case "$0" in
    on)
        start_server
        ;;
    off)
        stop_server
        ;;
    *)
        echo "Usage: $0 {on|off}"
        ;;
esac
