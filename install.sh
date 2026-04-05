#!/bin/bash
set -e

echo "Installing dependencies..."
if command -v apt &>/dev/null; then
    echo "Using apt to install dependencies..."
    sudo apt update
    sudo apt install -y alsa-tools alsa-utils
elif command -v pacman &>/dev/null; then
    echo "Using pacman to install dependencies..."
    sudo pacman -Sy alsa-tools alsa-utils --noconfirm
elif command -v eopkg &>/dev/null; then
    echo "Using eopkg to install dependencies..."
    sudo eopkg up
    sudo eopkg it alsa-tools alsa-utils -y
elif command -v zypper &>/dev/null; then
    echo "Using zypper to install dependencies..."
    sudo zypper install -y alsa-tools alsa-utils hda-verb
elif command -v dnf &>/dev/null; then
    echo "Using dnf to install dependencies..."
    sudo dnf install -y alsa-tools alsa-utils
else
    echo "Error: Neither apt, pacman, eopkg, zypper, nor dnf found. Cannot install dependencies." >&2
    echo "Please install alsa-tools and alsa-utils manually and try again." >&2
    exit 1
fi

echo "Copying files..."
sudo cp huawei-soundcard-headphones-monitor.sh /usr/local/bin/
sudo cp huawei-soundcard-headphones-monitor.service /etc/systemd/system/

echo "Setting permissions..."
sudo chmod +x /usr/local/bin/huawei-soundcard-headphones-monitor.sh
sudo chmod 644 /etc/systemd/system/huawei-soundcard-headphones-monitor.service

echo "Setting up daemon..."
sudo systemctl daemon-reload
sudo systemctl enable huawei-soundcard-headphones-monitor.service
sudo systemctl restart huawei-soundcard-headphones-monitor.service

echo "----------------------------------------"
echo "Installation Complete!"
echo "Checking service status..."
sudo systemctl --no-pager status huawei-soundcard-headphones-monitor.service
