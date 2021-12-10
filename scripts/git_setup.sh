#!/bin/bash
set -o nounset		#don't ref undefined variables
set -o errexit		#don't ignore failing commands

echo "This script sets git variables on a host."

git clone --bare git@github.com:cuckoosec/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

echo "👌 Awesome, all set."