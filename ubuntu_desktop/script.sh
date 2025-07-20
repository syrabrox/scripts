#!/bin/bash
clear
set -e
echo "============================="
echo " System Setup Script v3.0.0"
echo "============================="

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing curl..."
sudo apt install -y curl

echo "Adding Brave browser repository..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "Adding Brave source list..."
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
https://brave-browser-apt-release.s3.brave.com/ stable main" | \
sudo tee /etc/apt/sources.list.d/brave-browser-release.list

echo "Installing Brave browser..."
sudo apt update
sudo apt install -y brave-browser

echo "Installing Discord..."
DISCORD_DEB="discord.deb"
wget -O $DISCORD_DEB https://stable.dl2.discordapp.net/apps/linux/0.0.102/discord-0.0.102.deb
sudo apt install -y ./$DISCORD_DEB
rm -f $DISCORD_DEB

echo "Installing Steam..."
STEAM_DEB="steam.deb"
wget -O $STEAM_DEB https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
sudo apt install -y ./$STEAM_DEB
rm -f $STEAM_DEB

echo "Installing Lutris v0.5.18..."
LUTRIS_DEB="lutris_0.5.18_all.deb"
wget -O $LUTRIS_DEB https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb
sudo apt install -y ./$LUTRIS_DEB
rm -f $LUTRIS_DEB

echo "Installing Stacer v1.1.0..."
STACER_DEB="stacer_1.1.0_amd64.deb"
wget -O $STACER_DEB https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/stacer_1.1.0_amd64.deb
sudo apt install -y ./$STACER_DEB
rm -f $STACER_DEB


echo "Installing Flatpak..."
sudo apt install -y flatpak gnome-software-plugin-flatpak

echo "Adding Flathub remote..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Updating Flatpak appstream metadata..."
flatpak update --appstream -y

echo "Installing Mission Center..."
flatpak install -y flathub io.missioncenter.MissionCenter

echo "Installing Sober..."
flatpak install -y flathub org.vinegarhq.Sober

echo "Creating local desktop entries..."
mkdir -p ~/.local/share/applications/

ln -sf /var/lib/flatpak/exports/share/applications/io.missioncenter.MissionCenter.desktop \
  ~/.local/share/applications/io.missioncenter.MissionCenter.desktop

ln -sf /var/lib/flatpak/exports/share/applications/org.vinegarhq.Sober.desktop \
  ~/.local/share/applications/org.vinegarhq.Sober.desktop

if ! grep -q "XDG_DATA_DIRS.*flatpak" ~/.profile; then
  echo 'export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share' >> ~/.profile
fi

echo "Applying Flatpak override for Sober to interact with Discord IPC..."
flatpak override --user \
  --filesystem=xdg-run/app/com.discordapp.Discord:create \
  --filesystem=xdg-run/discord-ipc-0 \
  org.vinegarhq.Sober
  
echo "Installing GRUB Customizer..."
sudo add-apt-repository -y ppa:danielrichter2007/grub-customizer
sudo apt update
sudo apt install -y grub-customizer

echo "Installed Flatpak apps:"
flatpak list

echo "Finalizing Flatpak desktop integration..."
flatpak --installations
flatpak update --appstream -y
flatpak rebuild-appstream --user

export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"

update-desktop-database ~/.local/share/applications/

echo "Checking for Flatpak desktop entries..."
ls ~/.local/share/applications | grep flatpak || echo "No flatpak entries found."

echo "Creating symlinks for Flatpak apps..."
ln -sf ~/.local/share/flatpak/exports/share/applications/*.desktop ~/.local/share/applications/

echo "Reminder: Press ALT+F2 and type 'r' to reload GNOME Shell if necessary."

echo "Setup complete ✅"
