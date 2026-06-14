
#!/usr/bin/env bash

set -e

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sddm

sudo systemctl start NetworkManager
sudo systemctl start bluetooth

flatpak remote-add \
--if-not-exists \
flathub \
https://dl.flathub.org/repo/flathub.flatpakrepo

if command -v fish >/dev/null 2>&1; then
    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

    if [ "$CURRENT_SHELL" != "$(which fish)" ]; then
        chsh -s "$(which fish)" "$USER"
    fi
fi
