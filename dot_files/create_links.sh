#!/usr/bin/env bash
# Create the proper links from ~/ to my dot files.

# exit after printing first argument to this function
function die {
    # echo the first argument
    echo $1

    exit 1
}

function super_link {
    file_name=$1
    link_target=$2

    [ ! -e $link_target -o -L $link_target ] || \
        die "ERROR! $link_target is not a link, so exiting."

    ln -sf $file_name $link_target
}

function make_directory {
    directory=$1

    if [ ! -e $directory ]
    then
        mkdir $directory
    else
        [ -d $directory ] || die "Error! $directory is not a directory"
    fi  
}

# bashrc files
super_link $HOME/docs/dot_files/dot_bashrc $HOME/.bashrc

# gitconfig files
super_link $HOME/docs/dot_files/dot_gitconfig $HOME/.gitconfig

# gitk files
super_link $HOME/docs/dot_files/dot_gitk $HOME/.gitk

# xcode uncrustify files
super_link $HOME/docs/dot_files/dot_uncrustifyconfig $HOME/.uncrustifyconfig

# git bash completion files
super_link $HOME/docs/dot_files/dot_git-completion.bash $HOME/.git-completion.bash

# ssh config files
#make_directory $HOME/.ssh
#super_link $HOME/docs/dot_files/dot_ssh_config $HOME/.ssh/config

# vim files
super_link $HOME/docs/dot_files/dot_vimrc $HOME/.vimrc