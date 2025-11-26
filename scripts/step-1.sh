#!/bin/bash
# https://github.com/Piercing666

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo su then try again" 2>&1
  exit 1
fi

# Checks for active network connection
if [[ -n "$(command -v nmcli)" && "$(nmcli -t -f STATE g)" != connected ]]; then
    awk '{print}' <<< "Network connectivity is required to continue."
    exit
fi


# Create Directories if needed
    # font directory
        if [ ! -d "$HOME/.fonts" ]; then
            mkdir -p "$HOME/.fonts"
        fi
        chown -R "$username":"$username" "$HOME"/.fonts
    # Background and Profile Image Directories
        if [ ! -d "$HOME/$username/Pictures/backgrounds" ]; then
            mkdir -p /home/"$username"/Pictures/backgrounds
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/backgrounds
        if [ ! -d "$HOME/$username/Pictures/profile-image" ]; then
            mkdir -p /home/"$username"/Pictures/profile-image
        fi
        chown -R "$username":"$username" /home/"$username"/Pictures/profile-image
    # Make Trash if not exists
        mkdir --parents ~/.local/share/Trash/files
        ln --symbolic ~/.local/share/Trash/files ~/.trash

# Update Repositories to PureOS Local
# sudo rm /etc/apt/sources.list && sudo touch /etc/apt/sources.list && sudo chmod +rwx /etc/apt/sources.list && sudo printf "deb https://repo.pureos.net/pureos byzantium main
# deb https://repo.pureos.net/pureos byzantium-security main
# deb https://repo.pureos.net/pureos byzantium-updates main" | sudo tee -a /etc/apt/sources.list


# Overkill is underrated 
apt update && upgrade -y
wait
apt full-upgrade -y
wait
sudo apt install -f
wait
sudo dpkg --configure -a
wait
apt install --fix-broken
wait
apt update && upgrade -y
wait
flatpak update
wait
apt auto-remove -y
wait

echo "Install Essentials"
    sudo apt install zip unzip gzip tar -y
    sudo apt install make -y
    sudo apt install curl -y
    sudo apt install dconf* -y
    sudo apt install gnome-tweaks -y
    sudo apt install papirus-icon-theme -y
    sudo apt install neovim -y
    wait

# Add Flathub Repo
    flatpak remote-add --if-not-exists --subset=floss flathub-floss https://flathub.org/repo/flathub.flatpakrepo

# Install Brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Brew to PATH
    echo >> /home/droidian/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/droidian/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt-get install build-essential -y
    brew install gcc

# Installing fonts
    echo "Installing Fonts"
    cd "$builddir" || exit
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
    unzip FiraCode.zip -d /home/"$username"/.fonts
    unzip Meslo.zip -d /home/"$username"/.fonts
    sudo apt install fonts-font-awesome fonts-noto-color-emoji -y
    sudo apt install ttf-mscorefonts-installer -y
    sudo apt install fonts-terminus -y
    sudo apt install fonts-noto-color-emoji -y
# Reload Font
    fc-cache -vf
    wait

# Enable GPS on Modems
    sudo mmcli -m any --location-enable-gps-nmea --location-enable-gps-raw

# Screenshot with phosh
    sudo apt-get install wl-clipboard
    wl-paste > ~/Pictures/Screenshots/"$(date +'%Y-%m-%d_%H:%M:%S').png"


reboot