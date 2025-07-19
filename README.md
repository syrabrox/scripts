# scripts
<details>
  <summary>Ubuntu Desktop</summary>
  ### Installing
  - Curl
  - Brave
  - Discord
  - Steam
  - Lutris
  - Stacer
  - Grub Customizer
  - Flatpak
  - Mission Center
  - Sober

  ### Run
  ```bash
    bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/ubuntu_desktop/script.sh)"
  ```
</details> 
<details>
  <summary>Server</summary>
  # 🔧 Simple Linux Backup & Restore Script

  This script creates compressed backups of important folders like `/var/lib/docker`, `/home/asa`, and `/media`.  
  It also supports **restore** and sends status updates to a Discord webhook.

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
    bash -c "$(curl -sS https://raw.githubusercontent.com/syrabrox/scripts/refs/heads/main/server/script.sh)"
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
