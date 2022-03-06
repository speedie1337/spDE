
# spDE Installer

clear
echo "            ____  _____ "
echo "  ___ _ __ |  _ \| ____|"
echo " / __| '_ \| | | |  _|  "
echo " \__ \ |_) | |_| | |___ "
echo " |___/ .__/|____/|_____|"
echo "     |_|                "
echo "$(<name)"
echo "Version: $(<ver)"

user="$(whoami)"
repo="https://github.com/speediegamer/spDE-resources" # New repo

if [[ $user = "root" ]]; then
	echo "Running as root, this is necessary!"
else
	echo "Not running as root, please run me as root! Did you run the wrong script? Run ./install.sh" && exit 1
fi

echo -n "Which user would you like to install dwm for? " && read user && echo "Ok, installing for $user!"

echo "Checking system"

if [[ -f "/usr/bin/git" ]]; then
	echo "Found git" && git=/usr/bin/git
else
	echo "Git not found" && git=null
fi

if [[ -f "/usr/bin/emerge" ]]; then
	echo "Found distro: Gentoo" && distro=gentoo
elif [[ -f "/usr/bin/apt" ]]; then
	echo "Found distro: Debian" && distro=debian
elif [[ -f "/usr/bin/pacman" ]]; then
	echo "Found distro: Arch" && distro=arch
elif [[ -f "/usr/bin/rpm" ]]; then
	echo "Found distro: RedHat" && distro=redhat
fi

if [[ -f "/usr/bin/emerge" ]]; then
        mkdir -pv /etc/portage/package.use
	echo "x11-libs/cairo X" > /etc/portage/package.use/cairo
	echo "media-plugins/alsa-plugins pulseaudio" > /etc/portage/package.use/alsa-plugins
	echo "x11-libs/cairo X" > /etc/portage/package.use/cairo
	echo "x11-base/xorg-server udev -minimal" > /etc/portage/package.use/xorg-server
	echo "media-libs/libvpx postproc" > /etc/portage/package.use/libvpx
	echo "media-libs/harfbuzz icu" > /etc/portage/package.use/harfbuzz
	echo "media-libs/libglvnd X" > /etc/portage/package.use/libglvnd
fi

# Gentoo
if [[ -f "/usr/bin/emerge" ]]; then
        emerge --sync || exit 1
	emerge --autounmask --verbose x11-libs/libXinerama x11-libs/libXft media-fonts/terminus-font neovim media-fonts/fontawesome picom x11-misc/xclip moc alsa-utils firefox-bin scrot feh dev-vcs/git && echo "Installed dependencies"
fi

# Debian
if [[ -f "/usr/bin/apt" ]]; then
        apt update || exit 1
	apt install libc6 libx11-6 libxinerama1 make gcc suckless-tools xfonts-terminus compton neovim moc alsa-utils fonts-font-awesome xclip scrot firefox git feh && apt build-dep dwm && echo "Installed dependencies"
fi

# Arch
if [[ -f "/usr/bin/pacman" ]]; then
        pacman-key --init ; pacman-key --populate archlinux # Snippet by @jornmann
        pacman -Sy || exit 1
	pacman -S libxft libxinerama terminus-font ttf-font-awesome base-devel picom moc alsa-utils firefox scrot git xclip feh neovim && echo "Installed dependencies"
fi

# RedHat/Fedora
if [[ -f "/usr/bin/yum" ]]; then
        yum install -y libXft-devel libXinerama-devel fontpackages-devel fontawesome-fonts-web xclip picom moc alsa-utils firefox scrot feh git neovim && echo "Installed dependencies"
fi

# Void Linux
if [[ -f "/usr/bin/xbps-install" ]]; then
        xbps-install -S base-devel libX11-devel libXft-devel libXinerama-devel freetype-devel terminus-font font-awesome alsa-utils firefox scrot moc git xclip feh fontconfig-devel picom xf86-input-libinput neovim && echo "Installed dependencies"
fi

# Check if we even installed anything..
if [[ -f "/usr/bin/git" ]]; then
	echo "Git found :D"
else
        clear && echo "Git was not found. This script is therefore probably broken. What a shame!" && exit
fi

# Prepare 'n stuff

mkdir -pv /usr/local/bin/.spDE && echo "Created /usr/local/bin/.spDE" && cd /usr/local/bin/.spDE || exit 1

# Clone repository
git clone $repo && echo "Cloned repository"

cd spDE-resources

cp .wallpaper.png "/usr/local/bin/.spDE/bg.png"

cd .config

cp -r dwm slstatus st dmenu /usr/local/bin/.spDE && echo "Copied source code"

cd /usr/local/bin/.spDE/dwm && make clean && make && echo "Compiled dwm" && echo "Installed dwm"
cd /usr/local/bin/.spDE/st && make clean && make && echo "Compiled st" && echo "Installed st"
cd /usr/local/bin/.spDE/dmenu && make clean && make && echo "Compiled dmenu"
cd /usr/local/bin/.spDE/slstatus && make clean && make && echo "Compiled slstatus" && echo "Installed slstatus"

cp -r /usr/local/bin/.spDE/dmenu/dmenu /usr/bin && echo "Copied dmenu binary"
cp -r /usr/local/bin/.spDE/dmenu/dmenu_run /usr/bin && echo "Copied dmenu_run binary"
cp -r /usr/local/bin/.spDE/dmenu/dmenu_path /usr/bin && echo "Copied dmenu_path binary"
cp -r /usr/local/bin/.spDE/dmenu/stest /usr/bin && echo "Copied stest binary"

chmod +x /usr/bin/dmenu && echo "Made dmenu binary executable"
chmod +x /usr/bin/dmenu_run && echo "Made dmenu_run binary executable"
chmod +x /usr/bin/dmenu_path && echo "Made dmenu_path binary executable"
chmod +x /usr/bin/stest && echo "Made stest binary executable"

rm -rf /usr/local/bin/dmenu && echo "Removed old dmenu binary"
rm -rf /usr/local/bin/dmenu_run && echo "Removed old dmenu_run binary"
rm -rf /usr/local/bin/dmenu_path && echo "Removed old dmenu_path binary"
rm -rf /usr/local/bin/stest && echo "Removed old stest binary"

chmod +x /usr/local/bin/.spDE/slstatus/slstatus && echo "Made slstatus executable"
chmod +x /usr/local/bin/.spDE/st/st && echo "Made st executable"
chmod +x /usr/local/bin/.spDE/dwm/dwm && echo "Made dwm executable"

if [[ -f /usr/bin/firefox-bin ]]; then
        cp /usr/bin/firefox-bin /usr/bin/firefox
elif [[ -f /usr/bin/scrot ]]; then
        mkdir /home/$user/Screenshots && touch /home/$user/Screenshots/.TempScreenshot.png
fi

if [[ -f /usr/bin/compton ]]; then
       cp /usr/bin/compton /usr/bin/picom
fi

echo "Installed dmenu" && echo "Installed software"

mkdir -pv /home/$user/.spDE

echo "Your config files will be in /home/$user/.spDE"

echo "/usr/local/bin/.spDE/slstatus/slstatus &" > /usr/bin/spDE
echo "/usr/bin/picom &" >> /usr/bin/spDE
echo "#!/bin/sh" > /usr/local/bin/setwallpaper-wm
echo "feh --bg-fill /usr/local/bin/.spDE/bg.png" > /usr/local/bin/setwallpaper-wm
ln -s "/usr/local/bin/setwallpaper-wm" "/usr/local/bin/.spDE/wallpaper"
echo "/usr/local/bin/.spDE/wallpaper" >> /usr/bin/spDE
echo "/usr/bin/xclip &" >> /usr/bin/spDE
echo "/usr/local/bin/.spDE/dwm/dwm" >> /usr/bin/spDE

echo "startx" > /home/$user/.zprofile
echo "startx" > /home/$user/.bash_profile

echo "alias vim='nvim'" > /home/$user/.bashrc
echo "alias vim='nvim'" > /home/$user/.zshrc
echo "export EDITOR='nvim'" >> /home/$user/.bashrc
echo "export EDITOR='nvim'" >> /home/$user/.zshrc

curl -o /usr/bin/sfetch-base https://raw.githubusercontent.com/speediegamer/sfetch/main/sfetch && echo "Downloaded sfetch"
echo "#!/usr/bin/$SHELL" > /usr/bin/sfetch
< /usr/bin/sfetch-base >> /usr/bin/sfetch && echo "Installed sfetch"
curl -o /usr/bin/fff https://raw.githubusercontent.com/dylanaraps/fff/master/fff && echo "Downloaded fff file manager"
curl -o /usr/bin/setwallpaper https://raw.githubusercontent.com/speediegamer/setwallpaper/main/setwallpaper && echo "Downloaded setwallpaper"

chmod +x /usr/local/bin/.spDE/wallpaper && echo "Made wallpaper binary executable"
chmod +x /usr/local/bin/setwallpaper-wm && echo "Made other wallpaper binary executable"
chmod +x /usr/bin/spDE && echo "Made spDE executable"
chmod +x /usr/bin/sfetch && echo "Made sfetch executable"
chmod +x /usr/bin/fff && echo "Made fff executable"
chmod +x /usr/bin/setwallpaper && echo "Made setwallpaper executable"

mkdir -pv /home/$user/.config/st
mkdir -pv /home/$user/.config/dwm
mkdir -pv /home/$user/.config/dmenu
mkdir -pv /home/$user/.config/slstatus

ln -sf /usr/local/bin/.spDE/dmenu/config.h /home/$user/.spDE/menu-config
ln -sf /usr/local/bin/.spDE/st/config.h /home/$user/.spDE/terminal-config
ln -sf /usr/local/bin/.spDE/dwm/config.h /home/$user/.spDE/wm-config
ln -sf /usr/local/bin/.spDE/slstatus/config.h /home/$user/.spDE/status-config
ln -sf /usr/local/bin/.spDE/wallpaper /home/$user/.spDE/wallpaper
ln -sf /usr/local/bin/.spDE/st/st /home/$user/.config/st/st
ln -sf /usr/local/bin/.spDE/dwm/dwm /home/$user/.config/dwm/dwm
ln -sf /usr/local/bin/.spDE/dmenu/dmenu /home/$user/.config/dmenu/dmenu
ln -sf /usr/local/bin/.spDE/dmenu/dmenu_run /home/$user/.config/dmenu/dmenu_run
ln -sf /usr/local/bin/.spDE/dmenu/dmenu_path /home/$user/.config/dmenu/dmenu_path
ln -sf /usr/local/bin/.spDE/dmenu/stest /home/$user/.config/dmenu/stest
ln -sf /usr/local/bin/.spDE/slstatus/slstatus /home/$user/.config/slstatus/slstatus

echo "#!$SHELL" > /usr/bin/sfetch && echo "Added $SHELL to /usr/bin/sfetch"
< /usr/bin/sfetch-base >> /usr/bin/sfetch && echo "Added sfetch code to /usr/bin/sfetch"

echo "/usr/bin/sfetch" >> /home/$user/.zshrc && echo "Added sfetch to /home/$user/.zshrc"
echo "/usr/bin/sfetch" >> /home/$user/.bashrc && echo "Added sfetch to /home/$user/.bashrc"

echo "Installed sfetch"

usermod -a -G wheel $user && echo "Added user to wheel group"
usermod -a -G audio $user && echo "Added user to audio group"
usermod -a -G video $user && echo "Added user to video group"

chown -R $user /home/$user && echo "Changed owner of /home/$user"
chmod -R 777 /home/$user && echo "Changed permissions of /home/$user to 777"

echo "/usr/bin/spDE" >> /home/$user/.xinitrc && echo "Added /usr/bin/spDE to .xinitrc"

echo "NOTE: If you don't use xinit, please add /usr/bin/spDE to your display manager"

clear
echo " _____ _                 _                        _ "
echo "|_   _| |__   __ _ _ __ | | __  _   _  ___  _   _| |"
echo "  | | | '_ \ / _  | '_ \| |/ / | | | |/ _ \| | | | |"
echo "  | | | | | | (_| | | | |   <  | |_| | (_) | |_| |_|"
echo "  |_| |_| |_|\__,_|_| |_|_|\_\  \__, |\___/ \__,_(_)"
echo "                                |___/               "
echo "spDE has been successfully installed!"
echo "If you have xinit and xorg-server you can just run startx"
echo "Otherwise install it and run startx!"
echo
echo "For advanced users:"
echo "Your config files are in /home/$user/.spDE/"
echo "Simply edit them with a text editor."
echo
echo "The source code itself is in /usr/local/bin/.spDE."
echo "You must recompile it by running make after performing changes!"
echo
echo "If you enjoy this, please go support suckless.org!"
echo
echo "Have a good day!"

exit 0
