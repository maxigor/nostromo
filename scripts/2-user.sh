#!/usr/bin/env bash
#github-action genshdoc
#
# @file User
# @brief User customizations and AUR package installation.
echo -ne "
-------------------------------------------------------------------------
 __    _  _______  _______  _______  ______    _______  __   __  _______ 
|  |  | ||       ||       ||       ||    _ |  |       ||  |_|  ||       |
|   |_| ||   _   ||  _____||_     _||   | ||  |   _   ||       ||   _   |
|       ||  | |  || |_____   |   |  |   |_||_ |  | |  ||       ||  | |  |
|  _    ||  |_|  ||_____  |  |   |  |    __  ||  |_|  ||       ||  |_|  |
| | |   ||       | _____| |  |   |  |   |  | ||       || ||_|| ||       |
|_|  |__||_______||_______|  |___|  |___|  |_||_______||_|   |_||_______|

-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: nostromo
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/nostromo/configs/setup.conf

sed -n '/'$INSTALL_TYPE'/q;p' ~/nostromo/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]
  then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed ${line}
done


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/nostromo/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed ${line}
  done
fi

export PATH=$PATH:~/.local/bin

mkdir ~/.config
#cp -r ~/nostromo/configs/.config ~/
cp ~/nostromo/configs/.Xresources ~/
cp ~/nostromo/configs/.xinitrc ~/
#cp ~/nostromo/configs/.zshrc ~/
mkdir ~/Downloads

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
