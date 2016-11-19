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

# ctags files
super_link $HOME/docs/dot_files/dot_ctags $HOME/.ctags

# screenrc files
super_link $HOME/docs/dot_files/dot_screenrc $HOME/.screenrc

# tmux.conf files
super_link $HOME/docs/dot_files/dot_tmux.conf $HOME/.tmux.conf

# inputrc files
super_link $HOME/docs/dot_files/dot_inputrc $HOME/.inputrc

# gitconfig files
super_link $HOME/docs/dot_files/dot_gitconfig $HOME/.gitconfig

# xcode files
super_link $HOME/docs/dot_files/dot_uncrustifyconfig $HOME/.uncrustifyconfig
super_link $HOME/docs/dot_files/dot_xvimrc $HOME/.xvimrc
super_link $HOME/docs/dot_files/dot_lldbinit $HOME/.lldbinit

# gitk files
# super_link $HOME/docs/dot_files/dot_gitk $HOME/.gitk

# git bash completion files
super_link $HOME/docs/dot_files/dot_git-completion.bash $HOME/.git-completion.bash

# ssh config files
#make_directory $HOME/.ssh
#super_link $HOME/docs/dot_files/dot_ssh_config $HOME/.ssh/config

# vim files
super_link $HOME/docs/dot_files/dot_vimrc $HOME/.vimrc
make_directory $HOME/.vim

# install vim vundles if it doesn't already exist
#if [ ! -d "$HOME/.vim/bundle/neobundle/.git" ] ; then
#   echo "cloning neobundle..."
#   echo
#   mkdir -p "$HOME/.vim/bundle"
#   mkdir -p "$HOME/.vim/bundle/neobundle"
#   git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle
#   echo
#   echo "installing all bundles by opening vim and running :BundleInstall"
#   vim +NeoBundleInstall +qall
#   echo
#   echo "There may be extra files that need to be installed by hand in order"
#   echo "to get all the vim bundles working correctly.  Read the top of .vimrc"
#   echo "and install everything that is needed (this is stuff like ghc-mod, hlint, etc)."
#   echo "You might want to install things with a cabal command like this:"
#   echo "(Remember, you might need to source your .bashrc to get the ~/.cabal/bin directory"
#   echo "added to the path)"
#   echo
#   echo "\`cabal install happy -j8 && source ~/.bashrc && cabal install ghc-mod hoogle hlint hdevtools -j8\`"
#else
#   vim +NeoBundleCheck +qall
#fi
