#!/bin/bash

main() {
    # Install Homebrew 
    isInstalled brew || {
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }

    echo 'Checking for Homebrew updates...'
    brew update

    # Install Pip 
    isInstalled pip || {
        echo 'Install pip...'
        easy_install pip
    }

    echo 'Checking for pip updates...'
    pip install --upgrade pip

    # Install git with gitk
    isInstalled gitk || {
        brew install git

        # Check to make sure that install path is correct
        if ! [ $(command -v git) == "/usr/local/bin/git" ]; then
            echo '[git] is not installed at /usr/local/bin/git'
            echo 'Attempting to fix this by running $brew doctor'

            # If not correct path, run:
            brew doctor
            echo 'Exiting prematurely!!! Setup did not complete!!!'
        fi
    }

    # Check if Xcode is installed
    if xcode-select -p >/dev/null ; then
        echo '[Xcode] is already installed'
    else
        echo 'Install Xcode!!!'
        echo 'Then run `xcode-select --install` to install command line tools!!!'
        echo 'Exiting prematurely!!! Setup did not complete!!!'
        exit 1
    fi

    # Install RubyGems
    isInstalled gem || {
        echo 'Check out Xcode.txt for installation instructions...'
        echo 'Exiting prematurely!!! Setup did not complete!!!'
        exit 1
    }

#   # Install rbenv
#   isInstalled rbenv || {
#       brew install rbenv ruby-build
#       ruby_version=`egrep "^\s+2\.\d+\.\d+$" <(rbenv install -l) | tail -1`
#       echo "Installing ruby version: $ruby_version"
#       rbenv install $ruby_version
#       rbenv global $ruby_version
#       rbenv rehash
#       source ~/.bash_profile
#   }

    # Install Plug - Vim plugin Manager
    if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
        echo '[Plug] is already installed'
    else
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    
    # Install Alcatraz - Plugin Manager
    # if [ -d "$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin/" ]; then
    #     echo '[Alcatraz] is already installed'
    # else
    #     curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
    # fi
    ##########################################################################################
    # Uninstall Alcatraz                                                                     #
    #rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin #
    # Remove all cached data                                                                 #
    #rm -rf ~/Library/Application\ Support/Alcatraz                                          #
    ##########################################################################################

    isInstalled vapor || {
      brew tap vapor/tap
      brew install vapor/tap/vapor
    }
    isInstalled tmux || {
      brew install tmux
    }
    isInstalled node || {
      brew install node
    }
    isInstalled tree || {
      brew install tree
    }
    isInstalled mint || {
      brew install mint
    }
    isInstalled fzy || {
      brew install fzy
    }
    isInstalled ag || {
      brew install the_silver_searcher
    }
    isInstalled bundle || {
      gem install bundler
    }
    # isInstalled pod || { gem install cocoapods }
    # isInstalled sourcekitten || { brew install sourcekitten }
    # isInstalled hub || { brew install hub }
    # isInstalled ctags || { brew install ctags }
    # isInstalled mitmproxy || { sudo -H pip install mitmproxy --upgrade --ignore-installed six }
    # isInstalled postgres || { brew install postgres }
    # isInstalled swiftgen || { brew install swiftgen }
    # isInstalled stack || { brew install haskell-stack }
    # isInstalled fastlane || { brew cask install fastlane }
    # isInstalled xctool || { brew install -v --HEAD xctool }
    # isInstalled carthage || { brew install carthage }
    # isInstalled xcversion || { gem install xcode-install }
    # isInstalled swiftlint || {
    #     brew install swiftlint
    #     echo 'Add this script to your Xcode project:'
    #     echo ''
    #     echo '#if command -v swiftlint >/dev/null ; then'
    #     echo '#    swiftlint'
    #     echo '#else'
    #     echo '#    echo "SwiftLint does not exist, download from https://github.com/realm/SwiftLint"'
    #     echo '#    echo "or"'
    #     echo '#    echo "Run `brew install swiftlint`"'
    #     echo '#fi'
    # }
}

# Check if already installed
function isInstalled {
    COMMAND=$1
    if command -v $COMMAND >/dev/null ; then
        echo "[$COMMAND] is already installed"
        return 0
    else
        echo "Installing [$COMMAND]"
        return 1
    fi
}

main "$@"
