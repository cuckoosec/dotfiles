#!/bin/bash

# Define a function which renames a "target" to "target-COPY-datetime"
# if the file exists and is not a symlink
backup() {
  # TODO: Backup retention?
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
    
      location="${target}-COPY-$(date+'%Y%m%d%H%M%S')"
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

echo "Restarting services"
#sudo systemctl restart ssh