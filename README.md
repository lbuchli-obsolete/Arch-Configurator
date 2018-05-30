# Arch-Configurator

This is a script used for configuring Arch-Based distributions (pacman is required)
It is mostly written for myself and thus not very user-friendly or error-tolerating.

## Preview
![picture](https://github.com/CubePhoenix/Arch-Configurator/raw/master/screenshot.png "Looks like this after installation")

To install, clone the repository into any directory and type:

```bash
./install.sh
```

If that doesn't work, use
```bash
chmod +x install.sh
```
first to make the .sh file executable.

My configuration is built ontop of i3-gaps. (The keyboard shortcuts are mostly the original
ones)

## After the installation, it is recommended to follow some more steps:

Change following variables in different configs. You'll find the configs with:
```bash
sudo find /etc/ -type f -exec grep 'EDITOR=/usr/bin/nano' {} \\; -print
```

Variables:
```bash
EDITOR=/usr/bin/nvim
BROWSER=Firefox
RANGER_LOAD_DEFAULT_RC=FALSE
```

Also change the default terminal to termite (this is different per desktop)
But can probably done somewhat like this:
```bash
gsettings set com.deepin.wrap.gnome.desktop.default-applications.terminal exec /usr/bin/termite
gsettings set com.deepin.wrap.gnome.desktop.default-applications.terminal exec-arg \"-x\"
```

Lastly, change the git username in gitconfig
```bash
git config --global user.name \"John Doe\"
git config --global user.email johndoe@example.com
```
And [generate an ssh key for git](https://help.github.com/articles/connecting-to-github-with-ssh/)
And add it to your .bash_profile so it will get loaded when you use a terminal:
```bash
eval $(keychain --eval --quiet id_ed25519 id_rsa ~/.ssh/MYKEY)
```
