#
# ~/.bash_profile
#

#EDITOR=vim

# start ssh agent so we can add key files
eval `ssh-agent -s`

# Append some go stuff to the path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

[[ -f ~/.bashrc ]] && . ~/.bashrc
