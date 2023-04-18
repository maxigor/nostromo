#!/usr/bin/env bash
#github-action genshdoc
#
# @file Post-Setup
# @brief Finalizing installation configurations and cleaning up after script.
echo -ne "
-------------------------------------------------------------------------
 __    _  _______  _______  _______  ______    _______  __   __  _______ 
|  |  | ||       ||       ||       ||    _ |  |       ||  |_|  ||       |
|   |_| ||   _   ||  _____||_     _||   | ||  |   _   ||       ||   _   |
|       ||  | |  || |_____   |   |  |   |_||_ |  | |  ||       ||  | |  |
|  _    ||  |_|  ||_____  |  |   |  |    __  ||  |_|  ||       ||  |_|  |
| | |   ||       | _____| |  |   |  |   |  | ||       || ||_|| ||       |
|_|  |__||_______||_______|  |___|  |___|  |_||_______||_|   |_||_______|

------------------------------------------------------------------------

                    Automated Arch Linux Installer
                        SCRIPTHOME: nostromo
-------------------------------------------------------------------------

Final Setup and Configurations
GRUB EFI Bootloader Install & Check
"
source ${HOME}/nostromo/configs/setup.conf

if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi

echo -ne "
-------------------------------------------------------------------------
               Creating (and Theming) Grub Boot Menu
-------------------------------------------------------------------------
"
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${ENCRYPTED_PARTITION_UUID}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi
# set kernel parameter for adding splash screen
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& splash /' /etc/default/grub

echo -e "Installing CyberRe Grub theme..."
THEME_DIR="/boot/grub/themes"
THEME_NAME=CyberRe
echo -e "Creating the theme directory..."
mkdir -p "${THEME_DIR}/${THEME_NAME}"
echo -e "Copying the theme.. e."
cd ${HOME}/nostromo
cp -a configs${THEME_DIR}/${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}
echo -e "Backing up Grub config..."
cp -an /etc/default/grub /etc/default/grub.bak
echo -e "Setting the theme as the default..."
grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
echo -e "Updating grub..."
cp -r ${HOME}/nostromo/configs/default/grub /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "All set!"




echo -ne "
-------------------------------------------------------------------------
                        Installing Fonts
-------------------------------------------------------------------------
"
cd ~/Downloads/
git clone https://github.com/maxigor/fonts
sudo cp -r fonts/* /usr/share/fonts/TTF/
sudo fc-cache -fv

echo -ne "
-------------------------------------------------------------------------
                        Symlink directory
-------------------------------------------------------------------------
"
ln -s $HOME/nostromo/configs/.config/alacritty $HOME/.config/alacritty
ln -s $HOME/nostromo/configs/.config/bspwm $HOME/.config/bspwm
ln -s $HOME/nostromo/configs/.config/dunst $HOME/.config/dunst
ln -s $HOME/nostromo/configs/.config/hexchat $HOME/.config/hexchat
ln -s $HOME/nostromo/configs/.config/jgmenu $HOME/.config/jgmenu 
ln -s $HOME/nostromo/configs/.config/neofetch $HOME/.config/neofetch
ln -s $HOME/nostromo/configs/.config/nvim $HOME/.config/nvim
ln -s $HOME/nostromo/configs/.config/polybar $HOME/.config/polybar
ln -s $HOME/nostromo/configs/.config/qBittorrent $HOME/.config/qBittorrent
ln -s $HOME/nostromo/configs/.config/rofi $HOME/.config/rofi
ln -s $HOME/nostromo/configs/.config/sxhkd $HOME/.config/sxhkd
ln -s $HOME/nostromo/configs/.config/wallpaper $HOME/.config/wallpaper
ln -s $HOME/nostromo/configs/.config/.fehbg $HOME/.config/.fehbg
ln -s $HOME/nostromo/configs/.config/pavucontrol.ini $HOME/.config/pavucontrol.ini
ln -s $HOME/nostromo/configs/.config/picom.conf $HOME/.config/picom.conf
ln -s $HOME/nostromo/configs/.config/.starship.toml $HOME/.config/.starship.toml

ln -s $HOME/nostromo/configs/.zshrc $HOME/.zshrc
echo -ne "
-------------------------------------------------------------------------
                        Installing XQP
-------------------------------------------------------------------------
"

cd ~/Downloads
git clone https://github.com/baskerville/xqp.git
cd xqp
make
sudo make install

rm -rf ~/Downloads/xqp

echo -ne "
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"

echo "Enabling NetworkManager"
systemctl enable NetworkManager.service

echo "Enabling Ly Display Manager..."
sudo systemctl enable ly.service
sudo cp ~/nostromo/configs/config.ini /etc/ly/

echo "Enabling and Starting NordVPN..."
groupadd -r nordvpn
sudo usermod -aG nordvpn $USER
sudo systemctl enable nordvpnd.service
sudo systemctl start nordvpnd.service

modprobe btusb
echo "enabling and starting bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "enabling and starting Samba serivce"
sudo systemctl enable smb.service
sudo systemctl start smb.service

echo -ne "
-------------------------------------------------------------------------
                        Setting up Git Account
-------------------------------------------------------------------------
"

echo "Configuring git email and user..."
git config --global user.email "maxigor.ferreira@gmail.com"
git config --global user.name "Max"

echo "done"


echo -ne "
-------------------------------------------------------------------------
               Enabling (and Theming) Plymouth Boot Splash
-------------------------------------------------------------------------
"
PLYMOUTH_THEMES_DIR="$HOME/nostromo/configs/usr/share/plymouth/themes"
PLYMOUTH_THEME="hexagon_red" # can grab from config later if we allow selection
mkdir -p /usr/share/plymouth/themes
echo 'Installing Plymouth theme...'

cp -rf ${PLYMOUTH_THEMES_DIR}/${PLYMOUTH_THEME} /usr/share/plymouth/themes

sed -i 's/HOOKS=(base udev*/& plymouth/' /etc/mkinitcpio.conf # add plymouth after base udev

plymouth-set-default-theme -R hexagon_red # sets the theme and runs mkinitcpio
echo 'Plymouth theme installed'

echo -ne "
-------------------------------------------------------------------------
                    Cleaning
-------------------------------------------------------------------------
"
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers


rm -r /home/$USERNAME/paru

# Replace in the same state
cd $pwd
