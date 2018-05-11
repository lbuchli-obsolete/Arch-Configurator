#!/bin/bash

#----------------------
# Package installation
#----------------------

#echo "Type in the user directory you want to install to, then press [ENTER] to continue"
#read -r home_dir
home_dir=$HOME

# Update
sudo pacman -Syu --noconfirm

read -p "Do you want to install the dependencies? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing Dependencies..."
    # Install used packages
    sudo pacman --noconfirm -S termite i3-gaps compton feh rofi polybar xorg-xrdb git xcompmgr scrot

    # install polybar (which we have to do without root)
    git clone https://aur.archlinux.org/polybar.git
    cd ./polybar
    makepkg -si --noconfirm
    cd ..
    /bin/rm -r -f ./polybar
fi

read -p "Do you want to install other tools? (vim, ranger)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing Tools..."
    sudo pacman --noconfirm -S vim ranger

    # Also moving configs
    cp ./.vimrc $home_dir/.vimrc
    ranger --copy-config=all

    if [ -z "$RANGER_LOAD_DEFAULT_RC" ]; then
        # Make ranger use our config
        echo 'export RANGER_LOAD_DEFAULT_RC=FALSE' >> ~/.bashrc 
    fi

    # Install the Markdown plugin for vim (using Pathogen)
    mkdir $home_dir/.vim
    git clone https://github.com/tpope/vim-pathogen.git $home_dir/.vim/

    git clone https://github.com/plasticboy/vim-markdown $home_dir/.vim/bundle
    git clone --recursive https://github.com/python-mode/python-mode $home_dir/.vim/bundle
fi

#-----------------------
# Config File Placement
#-----------------------

# Make direcotries to put stuff into
mkdir $home_dir/.config/i3
mkdir $home_dir/.config/i3/assets
mkdir $home_dir/.config/i3/scripts
mkdir $home_dir/.config/polybar
mkdir $home_dir/.config/termite
mkdir $home_dir/.config/rofi

cp ./i3/config $home_dir/.config/i3/config
cp -r ./assets $home_dir/.config/i3
cp ./wallpaper.sh $home_dir/.config/i3/scripts/wallpaper.sh
cp ./launchpb.sh $home_dir/.config/i3/scripts/launchpb.sh
cp ./power/poweroff.sh $home_dir/.config/i3/scripts/poweroff.sh
cp ./power/reboot.sh $home_dir/.config/i3/scripts/reboot.sh
cp ./power/logout.sh $home_dir/.config/i3/scripts/logout.sh
cp ./pbconfig $home_dir/.config/polybar/config
cp ./termitecfg $home_dir/.config/termite/config
cp ./roficonfig $home_dir/.config/rofi/config

cp ./power/poweroff.desktop $home_dir/.local/share/applications/poweroff.desktop
cp ./power/reboot.desktop $home_dir/.local/share/applications/reboot.desktop
cp ./power/logout.desktop $home_dir/.local/share/applications/logout.desktop

chmod +x $home_dir/.config/i3/scripts/*

#-------
# Other
#-------

# add direct path to .desktop files
sed -i "s|~|$home_dir|g" $home_dir/.local/share/applications/poweroff.desktop
sed -i "s|~|$home_dir|g" $home_dir/.local/share/applications/reboot.desktop
sed -i "s|~|$home_dir|g" $home_dir/.local/share/applications/logout.desktop

#sudo xrdb $home_dir/.config/i3/configs/.Xresources

echo "Done. It is recommended to restart your computer now."
