#!/bin/bash
clear
stage=0
part=0
username=whoami
obas=$HOME/OBAS

install_from_list() {
	mapfile -t pkgs < "$1"
	sudo apt-get install "${pkgs[@]}" -yy	
}

install_essentials () {
	install_from_list "$obas/essentials.txt"
}

install_extras () {

	sudo add-apt-repository ppa:libretro/stable -y >/dev/null
	sudo apt-get update -yy > /dev/null

	install_from_list "$obas/extras.txt"

	wget --quiet "https://discordapp.com/api/download?platform=linux&format=deb" -O discord.deb
	sudo gdebi discord.deb --n >/dev/null
	rm discord.deb

	wget --quiet "https://files.multimc.org/downloads/multimc_1.4-1.deb" -O multimc.deb
	sudo gdebi multimc.deb --n >/dev/null
	rm multimc.deb

	echo "steam &" >> $HOME/.config/openbox/autostart
	echo "discord &" >> $HOME/.config/openbox/autostart
	
	sudo adduser $USER libvirt
	sudo adduser $USER libvirt-qemu
}


echo -e "\e[32mInstall essential software?  \e[0m"
read essentials
echo -e "\e[32mInstall extra software?  \e[0m"
read extra

echo -e "\e[32mCreating directories\e[0m"
cd $HOME
mkdir .programs Downloads Desktop Videos Music
mkdir -p .local/share .vim/plugged $HOME/.local/$username

echo -e "\e[32mCopying dot files\e[0m"
cp -a $obas/home/* .

sudo apt-get update -yy > /dev/null

let "stage++"
echo -e "\e[32mInstalling Openbox\e[0m"
	
	sudo apt-get install software-properties-common -yy > /dev/null
	sudo add-apt-repository ppa:mmstick76/alacritty

	install_from_list "$obas/openbox.txt"

	cd .programs
	wget --quiet "https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-central/firefox-78.0a1.en-US.linux-x86_64.tar.bz2" -O firefox.tar.bz2
	tar -xf firefox.tar.bz2
	rm firefox.tar.bz2
	
	wget --quiet "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -O bitwarden.AppImage >/dev/null
	chmod +x bitwarden.AppImage

	git clone --quiet https://github.com/trapd00r/LS_COLORS >/dev/null
	cd LS_COLORS
	./install.sh

	cd $HOME

[ $essentials = "y" ] && install_essentials
[ $extra = "y" ] && install_extras

echo -e "\e[32mChanging ZSH to default shell\e[0m"
chsh -s $(which zsh)
