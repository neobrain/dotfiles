#!/bin/bash

# Helper script to set up symbolic links from the home directory to files in this repository

pushd dot > /dev/null
for file in *
do
  if [[ "$file" == "setup.sh" ]]
  then
    continue
  fi

  if [ -L "$HOME/.$file" ]
  then
    echo -n "Removing old link ~/.$file -> `readlink -f $HOME/.$file`;  "
    rm $HOME/.$file
  fi

  if [[ -e "$HOME/.$file" ]]
  then
    echo "~/.$file is not a symlink, skipping"
    continue
  fi

  export linkpath=`realpath --relative-to=$HOME $file`
  echo -e "Adding symlink for ~/.$file -> $linkpath\n"
  ln -s $linkpath ~/.$file
done
popd > /dev/null
