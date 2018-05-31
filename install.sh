#!/bin/bash

#----------------------
# Package installation
#----------------------

#echo "Type in the user directory you want to install to, then press [ENTER] to continue"
#read -r home_dir
home_dir=$HOME

# Update
sudo pacman -Syu --noconfirm

echo
read -p "Do you want to install the dependencies? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing Dependencies..."
    # Install used packages
    sudo pacman --noconfirm -S termite i3-gaps compton feh rofi polybar xorg-xrdb git xcompmgr scrot perl-anyevent-i3 ctags
    sudo pacman --noconfirm -S gsimplecal numix-gtk-theme ttf-font-awesome

    # configurate git
    git config --global --add url."git@github.com:".insteadOf "https://github.com/"

    # install polybar (which we have to do without root)
    git clone https://aur.archlinux.org/polybar.git
    cd ./polybar
    makepkg -si --noconfirm
    cd ..
    /bin/rm -r -f ./polybar
fi

echo
read -p "Do you want to install other tools? (vim, ranger)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing Tools..."
    sudo pacman --noconfirm -S python python-pip python2 python2-pip go go-tools
    sudo pip3 install neovim
    sudo pip install neovim
    go get -u github.com/mdempsky/gocode
    sudo pacman --noconfirm -S neovim ranger curl evince texlive-core
    mkdir $home_dir/.config/nvim/bundle

    # Also move configs
    cp -r ./nvim $home_dir/.config
    cp -r ./ranger $home_dir/.config/

    # install neovim plugin-manager (vim-plug)
    curl -fLo $home_dir/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    chmod +x $home_dir/.config/ranger/scope.sh

    ranger --copy-config=all
    ranger --copy-config=scope

    echo
    read -p "Append to System Configs? (Only do this ONCE)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Appending to System Configs..."
	    sudo echo 'Color' >> /etc/pacman.conf

        # Make ranger use our config
        #echo "RANGER_LOAD_DEFAULT_RC=FALSE" >> $home_dir/.bash_profile

	    # make ranger use vim instead of nano
	    #echo "EDITOR=vim" >> $home_dir/.bash_profile

        # Make pacman use color
    fi
fi

echo
read -p "Do you want to install a music player? (ncmpcpp, mpd)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   sudo pacman -S --noconfirm mpd ncmpcpp mpc base-devel boost yajl libmpdclient

   mkdir $home_dir/.ncmpcpp
   mkdir $home_dir/.config/mpd
   mkdir $home_dir/.config/mpd/soundcloud

   # SoundCloud Support
   #git clone git://git.musicpd.org/master/mpd.git $home_dir/.config/mpd/soundcloud 
   #sh $home_dir/.config/mpd/soundcloud/autogen.sh
   #$home_dir/.config/mpd/soundcloud/configure --enable-soundcloud   
   #make -C $home_dir/.config/mpd/soundcloud/

   cp -r ./music/.ncmpcpp $home_dir/
   cp -r ./music/mpd $home_dir/.config/
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
mkdir $home_dir/.config/i3/workspaces
mkdir $home_dir/.config/gtk-3.0
mkdir $home_dir/.config/gsimplecal

mkdir $home_dir/go
mkdir $home_dir/go/bin

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
cp ./gscconfig $home_dir/.config/gsimplecal/config
cp ./gtk/gtk.css $home_dir/.config/gtk-3.0/gtk.css
cp ./gtk/settings.ini $home_dir/.config/gtk-3.0/settings.ini

cp ./power/poweroff.desktop $home_dir/.local/share/applications/poweroff.desktop
cp ./power/reboot.desktop $home_dir/.local/share/applications/reboot.desktop
cp ./power/logout.desktop $home_dir/.local/share/applications/logout.desktop

cp -n ./bash_profile $home_dir/.bash_profile

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
echo
echo "Next steps: Change following variables in different configs. You'll find the configs with:"
echo "sudo find /etc/ -type f -exec grep 'EDITOR=/usr/bin/nano' {} \\; -print"
echo
echo "Variables:"
echo "EDITOR=/usr/bin/nvim"
echo "BROWSER=Firefox"
echo "RANGER_LOAD_DEFAULT_RC=FALSE"
echo
echo "Also change the default terminal to termite (this is different per desktop)"
echo "But can probably done somewhat like this:"
echo "gsettings set com.deepin.wrap.gnome.desktop.default-applications.terminal exec /usr/bin/termite"
echo "gsettings set com.deepin.wrap.gnome.desktop.default-applications.terminal exec-arg \"-x\""
echo
echo "Lastly, change the git username in gitconfig"
echo "git config --global user.name \"John Doe\""
echo "git config --global user.email johndoe@example.com"
echo "And generate an ssh key for git like this: https://help.github.com/articles/connecting-to-github-with-ssh/"
echo "And to use the ssh key every time when starting a shell:"
echo "Add to your .bash_profile"
echo "eval \$(keychain --eval --quiet id_ed25519 id_rsa ~/.ssh/MYKEY)"
