# README

```bash
bash -c "$(curl -sS -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/script.sh)"
```
<details>
  <summary>🖥️ Ubuntu Desktop Setup</summary>

  ---

  ### 📦 Installierte Tools & Programme

  - 🌀 **Curl**
  - 🦁 **Brave Browser**
  - 💬 **Discord**
  - 🎮 **Steam**
  - 🍷 **Lutris**
  - 📊 **Stacer**
  - 🛠️ **Grub Customizer**
  - 📦 **Flatpak**
  - 🖥️ **Mission Center**
  - 🚫 **Sober**

  ---

  ### ▶️ Schnellstart

  ```bash
  bash -c "$(curl -sS -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/ubuntu_desktop/script.sh)"
  ```
</details> 

<details>
  <summary>🔧 Simple Linux Backup & Restore Script</summary>

  ---

  ## 📂 Features
  - Backup `/var/lib/docker`, `/home/asa`, `/media`
  - Restore from `.tar.gz` backups
  - Prevents multiple backup/restore runs (lockfile)
  - Discord notifications via webhook (saved in a file "webhook.txt")
  - Interactive menu or command-line arguments

  ---

  ## 🚀 Quick Start

  ### Run directly:
  ```bash
  bash -c "$(curl -sS -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/backup_restore/script.sh)"
  ```

  ## 💻 Usage
  with menu:
  ```bash
  ./backup.sh
  ```
  direct mode:
  ```bash
  ./backup.sh backup
  ```
  ```bash
  ./backup.sh restore
  ```
  background mode:
  nohup ./backup.sh > /dev/null 2>&1 &
  ```bash
  nohup ./backup.sh backup > /dev/null 2>&1 &
  ```
  ```bash
  nohup ./backup.sh restore > /dev/null 2>&1 &
  ```
</details>
# ToDo

- [] On Restore check if Docker, Python3 exists or install
