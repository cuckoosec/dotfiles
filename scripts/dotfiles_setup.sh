#!/bin/bash

# Define a function which renames a "target" to "target-COPY-datetime"
# if the file exists and is not a symlink
backup() {
  # TODO: Backup retention?
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
    
      location="${target}-COPY-$(date --iso-8601=seconds)"
      cp --archive "${target}" "${location}"
      echo "-----> Moved $target config file to $location"

    fi
  fi
}

replace() {
  config=$1
  replacement=$2
  
  if [ ! -e "$config" ]; then
  
    echo "-----> Replacing old $config with new $replacement"
    cp -f "$config" "$replacement"
    
  fi
}

# For all dotfiles present, backup the target files and replace
# with new configuration file
for file in *; do
  if [ ! -d "$file" ]; then
    target="${HOME}"/."${file}" 
       
    if [[ "$file" =~ ^\..* ]]; then
      backup "$target"
      replace "$target" "$file"
    
    elif [[ "$file" =~ ssh*_config ]]; then
      original=/etc/ssh/"$file"
      backup "$original"
      replace "$original" "$replacement"
    
    elif [[ -e /usr/bin/firefox ]]; then
      # FIXME: needs to check if firefox is open
      backup "{$HOME}/.mozilla/firefox/*default-release"
      replace "$_" "$file"

    fi
  fi
done

echo "Dowloading oh-my-zsh"
# FIXME
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


backup $HOME/.zshrc
rm $HOME/.zshrc && ln -s ./.zshrc $HOME/.zshrc

backup $HOME/.tmux.conf
rm $HOME/.tmux.conf && ln -s ./.tmux.conf $HOME/.tmux.conf

backup $HOME/.selected_editor
rm $_ && ln -s ./selected_editor $HOME/.selected_editor

backup $HOME/.gnupg/gpg-agent.conf
rm $_ && ln -s ./gpg-agent.conf $/HOME/.gnupg/gpg-agent.conf

ln -s 

ls -la | awk '{print $9}' | grep -P "^\..*-COPY-"

ln -s ./configs/torrc /etc/tor/torrc

ln -s ./gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

rm $HOME/.config/micro/bindings.json
ln -s $HOME/dotfiles/configs/micro/bindings.json $HOME/.config/micro/bindings.json
rm $HOME/.config/micro/settings.json
ln -s $HOME/dotfiles/configs/micro/settings.json $HOME/.config/micro/settings.json


echo "Restarting services"
#sudo systemctl restart ssh
