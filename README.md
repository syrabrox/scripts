# README
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
    bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/v1.0.0/ubuntu_desktop/script.sh)"
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
    bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/v1.0.0/backup_restore/script.sh)"
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
</details> 
