#!/bin/sh

UNAME=`uname -s`

if test -d $HOME/miniconda; then
    echo "Warnning: the $HOME/miniconda already exists !"
    exit 1
fi

case "x$UNAME" in
    "xDarwin" )
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
        sh ~/miniconda.sh -b -p $HOME/miniconda
        echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.zshrc
        echo 'alias miniconda="source $HOME/miniconda/bin/activate"' >> ~/.zshrc
        source ~/.zshrc
    ;;
    "xLinux" )
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
        sh ~/miniconda.sh -b -p $HOME/miniconda
        echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bash_profile
        echo 'alias miniconda="source $HOME/miniconda/bin/activate"' >> ~/.bash_profile
        source ~/.bash_profile
    ;;
    * )
        echo "Error: Your platform $UNAME is not supported !"
    ;;
esac

# Usage:
#     miniconda
#     conda
#
