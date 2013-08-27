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

    if [ ! -e $link_target -o -L $link_target ]
	then
		ln -sf $file_name $link_target
	else
		echo "ERROR! $link_target is not a link, so exiting."
	fi
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
super_link $HOME/docs/dot_files/dot_bash_profile $HOME/.bash_profile

# screenrc files
super_link $HOME/docs/dot_files/dot_screenrc $HOME/.screenrc

# gitconfig files
super_link $HOME/docs/dot_files/dot_gitconfig $HOME/.gitconfig

# gitk files
super_link $HOME/docs/dot_files/dot_gitk $HOME/.gitk

# xcode files
super_link $HOME/docs/dot_files/dot_uncrustifyconfig $HOME/.uncrustifyconfig
super_link $HOME/docs/dot_files/dot_xvimrc $HOME/.xvimrc

# git bash completion files
super_link $HOME/docs/dot_files/dot_git-completion.bash $HOME/.git-completion.bash

# ssh config files
#make_directory $HOME/.ssh
#super_link $HOME/docs/dot_files/dot_ssh_config $HOME/.ssh/config

# vim files
super_link $HOME/docs/dot_files/dot_vimrc $HOME/.vimrc

make_directory $HOME/.vim

# NERD_tree
super_link $HOME/docs/dot_files/dot_vim_nerdtree/ $HOME/.vim/nerdtree

