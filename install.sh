#!/bin/sh
# spDE Installer

clear
echo "            ____  _____ "
echo "  ___ _ __ |  _ \| ____|"
echo " / __| '_ \| | | |  _|  "
echo " \__ \ |_) | |_| | |___ "
echo " |___/ .__/|____/|_____|"
echo "     |_|                "
echo "spDE is licensed under the MIT license. Visit the repository for more information."
VER="1.0-r2"
echo "Version: $VER"

MSGBOX_01() {
  printf "\nWelcome to spDE $VER. spDE is a free software installation script for Gentoo, Arch, Artix, Debian, Void and RedHat GNU/Linux which deploys my Gentoo rice and dotfiles onto any supported GNU/Linux distribution."
  printf "\n\nIt was initially created to help me quickly deploy my rice on any machine but is now public and maintained."
  printf "\n\nNOTE: spDE (the installation scripts) are licensed under MIT. However the packages that will be installed may use a different license. None of them are non-free. Any such packages must be manually installed by the user."
  printf "\n\n* Docs: Complete spDE documentation can be found here: https://speedie.gq/spde.html"
  printf "\n* Donate: If you find spDE useful, consider donating to me here: https://speedie.gq/donate.html"
}

# Package list
gentoopkglist="x11-apps/xrdb \
x11-libs/libXinerama \
media-fonts/terminus-font \ 
app-editors/vim \
media-fonts/fontawesome \
x11-misc/picom \
x11-misc/xclip \
media-sound/moc \
media-sound/alsa-utils \
sys-process/htop \
www-client/firefox-bin \
media-gfx/maim \
media-gfx/sxiv \
dev-vcs/git \
x11-base/xorg-server \
x11-apps/xinit \
x11-misc/xwallpaper \
net-news/newsboat \ 
app-shells/zsh \
media-libs/imlib2 \
python \
media-gfx/imagemagick \
x11-apps/xsetroot \
x11-misc/wmctrl \
x11-apps/xmodmap \
app-misc/vifm \
media-gfx/ueberzug \
net-misc/yt-dlp"

debianpkglist="libc6 \
libx11-6 \
xorg-xrdb \
libxinerama1 \
make \
gcc \
xfonts-terminus \
compton \
vim \
moc \
alsa-utils \
fonts-font-awesome \
xclip \
maim \
firefox \
git \
sxiv \
htop \
xorg-server \
xinit \
newsboat \
zsh \
imlib2 \
xwallpaper \
python \
imagemagick \
xsetroot \
wmctrl \
vifm \
ueberzug \
xmodmap \
yt-dlp"

artixpkglist="libxinerama \
xorg-server \
terminus-font \
ttf-font-awesome \
base-devel \
picom \
alsa-utils \
firefox \
maim \
git \
xclip \
sxiv \
vim \
xorg-server \
xorg-xinit \
newsboat \
htop \
zsh \
xwallpaper \
python \
imagemagick \
xsetroot \
wmctrl \
vifm \
ueberzug \
xmodmap \
yt-dlp"

archpkglist="libxinerama \
xorg-xrdb \
terminus-font \
ttf-font-awesome \
base-devel \
picom \
moc \
alsa-utils \
firefox \
maim \
git \
xclip \ 
sxiv \
vim \
xorg-server \
xorg-xinit \
newsboat \
htop \
zsh \ 
xwallpaper \
python \
imagemagick \
xsetroot \
wmctrl \
vifm \
ueberzug \
xmodmap \
yt-dlp"

rhpkglist="newsboat \
xrdb \
libXinerama-devel \
fontpackages-devel \
fontawesome-fonts-web \ 
xclip \
picom \
moc \
alsa-utils \ 
firefox \
maim \
sxiv \
git \
vim \
xorg-xinit \
xorg-server \
htop \
zsh \ 
xwallpaper \
python \
imagemagick \
xsetroot \
xmodmap \
wmctrl \
vifm \
ueberzug \
yt-dlp"

voidpkglist="base-devel \
libX11-devel \
xrdb \
newsboat \
libXinerama-devel \
freetype-devel \
terminus-font \
font-awesome \
zsh \
alsa-utils \
xorg-server \
xinit \
firefox \
maim \
moc \
git \
xclip \
sxiv \
fontconfig-devel \
htop \
picom \
xf86-input-libinput \
vim \
xwallpaper \
python \
imagemagick \
xsetroot \
xmodmap \
wmctrl \
vifm \
ueberzug \
yt-dlp"

# Make sure we're running the script as root.
case "$(whoami)" in
"root") echo "STATUS: Running as root, this is necessary!" && runningasroot=true ;;
esac

# Check if we're running as root
case "$runningasroot" in
"") printf "\nWARNING: Not running as root, please run me again as root!\n"; exit 0 ;;
esac

GETDATA() {
  printf "$(MSGBOX_01)" && printf "\n===========================================\n"; read NULL
  printf "\nWhich user would you like to install dwm for? "
  read user # Ask what user to install for.
  printf "\nWhere do you want your spDE configuration files to be located? Recommended: /home/$user/.local/bin: >" read spdedir
}

GETDATA

ls /home/$user || printf "STATUS: Invalid user, resetting"; $0; exit 1

echo "Ok, installing for $user!"

# Check distribution and package manager!
ls /usr/bin/emerge > /dev/null && echo "STATUS: Found distro: Gentoo" && distro=gentoo
ls /usr/bin/apt > /dev/null && echo "STATUS: Found distro: Debian" && distro=debian
ls /usr/bin/pacman > /dev/null && echo "STATUS: Found distro: Arch Based Distro" && distro=arch
ls /usr/bin/yum > /dev/null && echo "STATUS: Found distro: RedHat" && distro=redhat

INSTALL_PACKAGES() {
# Gentoo
  if [ -e /usr/bin/emerge ]; then
  echo "You seem to be a based Gentoo user. Emerging might take a good while so please make sure your make.conf is optimized!!"
  mkdir -pv /etc/portage/package.use || exit 1
  echo "x11-libs/cairo X" > /etc/portage/package.use/cairo || exit 1
  echo "media-plugins/alsa-plugins pulseaudio" > /etc/portage/package.use/alsa-plugins || exit 1
  echo "x11-libs/cairo X" > /etc/portage/package.use/cairo || exit 1
  echo "x11-base/xorg-server udev -minimal" > /etc/portage/package.use/xorg-server || exit 1
  echo "media-libs/libvpx postproc" > /etc/portage/package.use/libvpx || exit 1
  echo "media-libs/harfbuzz icu" > /etc/portage/package.use/harfbuzz || exit 1
  echo "media-libs/libglvnd X" > /etc/portage/package.use/libglvnd || exit 1
  emerge-webrsync
  emerge --sync
  emerge --autounmask --verbose $gentoopkglist || printf "STATUS: Failed to install dependencies"; exit 1
  echo "STATUS: Installed dependencies"
  fi
  
  # Debian
  if [ -e /usr/bin/apt ]; then
  apt update || exit 1
  apt install $debianpkglist || printf "STATUS: Failed to install dependencies"; exit 1
  apt build-dep dwm || printf "STATUS: Failed to install dependencies"; exit 1
	  echo "STATUS: Installed dependencies"
  fi
  
  # Arch
  if [ -e /usr/bin/pacman ]; then
	  if $(< /etc/os-release | grep "Artix"); then
		  echo "Found Artix"
		  pacman -Sy || exit 1
		  pacman -S $artixpkglist || printf "STATUS: Failed to install dependencies"; exit 1 
		  echo "STATUS: Installed dependencies"
      else
	      echo "Found Arch"
          pacman-key --init ; pacman-key --populate archlinux # Snippet by @jornmann, im a normie gentoo user.
          pacman -Sy || printf "STATUS: Failed to sync repositories"; exit 1
	      pacman -S $archpkglist || printf "STATUS: Failed to install dependencies"; exit 1
	      echo "STATUS: Installed dependencies"
	  fi
  fi
  
  # RedHat/Fedora
  if [ -e /usr/bin/yum ]; then
          yum install -y $rhpkglist || printf "STATUS: Failed to install dependencies"; exit 1
		  echo "STATUS: Installed dependencies"
  fi
  
  # Void Linux
  if [ -e /usr/bin/xbps-install ]; then
          xbps-install -S $voidpkglist || printf "STATUS: Failed to install dependencies"; exit 1
		  echo "STATUS: Installed dependencies"
  fi

  # Check if we even installed anything..
  if [ -e /usr/bin/git ]; then
  	  echo "STATUS: Git found!" 
  else
      echo "STATUS: Git was not found. This script is therefore probably broken. What a shame!" && exit 1
  fi
}

# Install dynamic window manager
INSTALL_DWM() {
  git clone https://github.com/speedie-de/dwm.git && printf "\nSTATUS: Cloned dwm repository"
  cd dwm && printf "\nSTATUS: Changed directory into dwm source code"
  make clean install && printf "\nSTATUS: Compiled and installed dwm"
  cd ..
}

# Install suckless terminal
INSTALL_ST() {
  git clone https://github.com/speedie-de/st.git && printf "\nSTATUS: Cloned st repository"
  cd st && printf "\nSTATUS: Changed directory into st source code"
  make clean install && printf "\nSTATUS: Compiled and installed st"
  cd ..
}

# Install dmenu
INSTALL_DMENU() {
  git clone https://github.com/speedie-de/dmenu.git && printf "\nSTATUS: Cloned dmenu repository"
  cd dmenu && printf "\nSTATUS: Changed directory into dmenu source code"
  make clean install && printf "\nSTATUS: Compiled and installed dmenu"
  cd ..
}

# Install slock
INSTALL_SLOCK() {
  git clone https://github.com/speedie-de/slock.git && printf "\nSTATUS: Cloned slock repository"
  cd slock && printf "\nSTATUS: Changed directory into slock source code"
  make clean install && printf "\nSTATUS: Compiled and installed slock"
  cd ..
}

# Install xshbar
INSTALL_XSHBAR() {
  git clone https://github.com/speedie-de/xshbar && printf "\nSTATUS: Cloned xshbar repository"
  cd xshbar && printf "\nSTATUS: Changed directory into xshbar source code"
  cp xshbar /usr/bin && printf "\nSTATUS: Copied xshbar to /usr/bin"
  chmod +x /usr/bin/xshbar && printf "\nSTATUS: Make xshbar executable"
  cd ..
}

# Install pywal
INSTALL_PYWAL() {
  su -c "pip3 install --user pywal" $user
  printf "\nSTATUS: Installed Pywal"
}

INSTALL_VIFM() {
  cd /home/$user/.config
  git clone https://github.com/speedie-de/vifm && printf "\nSTATUS: Cloned vifm config"
  cd vifm && cp vifmrc vifmrun /usr/bin && printf "\nSTATUS: Installed vifm config"
  cd ..
}

# Install libXft-bgra
INSTALL_LXFT() {
  # Install libXft-bgra for Arch
  LXFT_ARCH() {
    git clone https://aur.archlinux.org/libxft-bgra && cd libxft-bgra && su -c "makepkg -i" $user
	cd .. && rm -rf libxft-bgra
	printf "\nSTATUS: Installed libxft-bgra"
  }
  
  # Install libXft-bgra for Gentoo
  LXFT_GENTOO() {
    mkdir -p /etc/portage/patches/x11-libs/libXft
	curl -o /etc/portage/patches/x11-libs/libXft/bgra.diff "https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1.diff"
    emerge x11-libs/libXft && printf "\nSTATUS: Installed libxft-bgra"
  }
  
  # Install libXft-bgra for most other distros
  LXFT_OTHER() {
    git clone https://github.com/uditkarode/libxft-bgra && cd libxft-bgra
    sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
	make install
	cd .. && rm -rf libxft-bgra
  }
  
  # Determine what to do
  ls /usr/bin/pacman && LXFT_ARCH
  ls /usr/bin/emerge && LXFT_GENTOO
  ls /usr/bin/apt && LXFT_OTHER
  ls /usr/bin/xbps-install && LXFT_OTHER
  ls /usr/bin/rpm && LXFT_OTHER
}

# Install zsh configs
INSTALL_SZSH() {
  OLDPWD=$PWD
  cd /home/$user && git clone https://github.com/speedie-de/szsh && cp -r szsh zsh && rm -rf szsh && printf "\nSTATUS: Installed szsh"
  cd $OLDPWD
}

# Install spDE
INSTALL_DE() {

  # Create directories
  mkdir -p $spdedir || printf "\nSTATUS: Failed to create $spdedir"; exit 1
  echo "STATUS: Created $spdedir" && cd $spdedir || printf "STATUS: Failed to change directory"; exit 1

  INSTALL_LXFT # Install libxft-bgra
  INSTALL_DWM # Install dwm
  INSTALL_ST # Install st
  INSTALL_DMENU # Install dmenu
  INSTALL_SLOCK # Install slock
  INSTALL_XSHBAR # Install xshbar
  INSTALL_PYWAL # Install pywal
  INSTALL_VIFM # Install vifm config
  INSTALL_SZSH # Install zsh config

  # Move around a few files
  if [ -e /usr/bin/firefox-bin ]; then
          mv /usr/bin/firefox-bin /usr/bin/firefox
  elif [ -e /usr/bin/compton ]; then
          mv /usr/bin/compton /usr/bin/picom
  fi

  echo "STATUS: Installed software"
}

WRITE_CONFIGS() {
  echo "/usr/bin/spDE" > /home/$user/.config/.xinitrc
  echo "ZDOTDIR=~/.config/zsh/dotfiles\nstartx /home/$user/.config/.xinitrc" > /home/$user/.zprofile
  mkdir -pv /home/$user/.config/newsboat && echo "Created newsboat directory"
  echo 'browser "firefox"' > /home/$user/.config/newsboat/config
  echo 'player "mpv"' >> /home/$user/.config/newsboat/config
  echo 'download-path "~/Downloads/%n"' >> /home/$user/.config/newsboat/config
  echo 'save-path "~/Downloads"' >> /home/$user/.config/newsboat/config
  echo 'reload-threads 20' >> /home/$user/.config/newsboat/config
  echo 'cleanup-on-quit yes' >> /home/$user/.config/newsboat/config
  echo 'text-width 74' >> /home/$user/.config/newsboat/config
  echo 'auto-reload yes' >> /home/$user/.config/newsboat/config && echo "Created newsboat config file"
  echo '__/blogs' >> /home/$user/.config/newsboat/urls
  echo 'https://speedie.gq/rss.xml' >> /home/$user/.config/newsboat/urls
  echo '__/wikis' >> /home/$user/.config/newsboat/urls
 
  # Add the wiki pages to newsboat
  if [ -e "/usr/bin/emerge" ]; then
          echo 'https://planet.gentoo.org/rss20.xml' >> /home/$user/.config/newsboat/urls
  elif [ -e "/usr/bin/pacman" ]; then
          echo 'https://archlinux.org/feeds/packages/x86_64/' >> /home/$user/.config/newsboat/urls
  elif [ -e "/usr/bin/xbps-install" ]; then
          echo 'https://github.com/void-linux/void-packages/commits/master.atom' >> /home/$user/.config/newsboat/urls
  fi
  
  echo "Created newsboat urls file"
  curl -o /usr/bin/sfetch https://raw.githubusercontent.com/speediegq/sfetch/main/sfetch && echo "Downloaded sfetch"
  echo "STATUS: Installed sfetch"
  
  chmod +x /usr/bin/spDE && echo "Made spDE executable"
  chmod +x /usr/bin/sfetch && echo "STATUS: Made sfetch executable"
  
  echo "/usr/bin/sfetch" >> /home/$user/.zshrc && echo "Added sfetch to /home/$user/.zshrc"
  echo "/usr/bin/sfetch" >> /home/$user/.bashrc && echo "Added sfetch to /home/$user/.bashrc"
  
  echo "STATUS: Installed sfetch"
 
  cat $spdedir/dwm/docs/example.Xresources $spdedir/st/docs/example.Xresources $spdedir/dmenu/docs/example.Xresources > /home/$user/.config/.Xresources && echo "STATUS: Downloaded .Xresources"
  echo "$VER" > $spdedir/ver && echo "STATUS: Write version info"
  
  ln -s /home/$user/.config/zsh/dotfiles/.zshrc /root/.config/zsh/dotfiles/.zshrc && echo "STATUS: Created .zshrc alias for root user"
}

SET_PERMISSIONS() {
  # Set groups
  usermod -a -G wheel $user && echo "STATUS: Added user to wheel group"
  usermod -a -G audio $user && echo "STATUS: Added user to audio group"
  usermod -a -G video $user && echo "STATUS: Added user to video group"
  usermod -a -G users $user && echo "STATUS: Added user to users group"
  
  # Change permissions
  chown -R $user /home/$user && echo "STATUS: Changed owner of /home/$user"
  chmod -R 777 /home/$user && echo "STATUS: Changed permissions of /home/$user to 777"
  chmod -R 777 /usr/local/bin && echo "STATUS: Changed permissions of /usr/local/bin"
  chmod -R 777 /home/$user/.local/bin && echo "STATUS: Changed permissions of /home/$user/.local/bin"
  chown -R $user /usr/local/bin && echo "STATUS: Changed owner of /usr/local/bin"
  chown -R $user /home/$user/.local/bin && echo "STATUS: Changed owner of /home/$user/.local/bin"
}

MISC() {
  chsh -s /bin/zsh $user && echo "Changed shell to zsh"
}

INSTALL_DE || exit 1
WRITE_CONFIGS || exit 1
SET_PERMISSIONS || exit 1
MISC || exit 1

clear
echo " _____ _                 _                        _ "
echo "|_   _| |__   __ _ _ __ | | __  _   _  ___  _   _| |"
echo "  | | | '_ \ / _  | '_ \| |/ / | | | |/ _ \| | | | |"
echo "  | | | | | | (_| | | | |   <  | |_| | (_) | |_| |_|"
echo "  |_| |_| |_|\__,_|_| |_|_|\_\  \__, |\___/ \__,_(_)"
echo "                                |___/               "
echo "spDE has been successfully installed!"
echo "Xorg server and xinit has also been installed."
echo "spDE should automatically run when you log in as $user"
echo "If not, just run 'startx'."
echo
echo "If it fails, you probably need a graphics driver."
echo "The package should be 'xf86-video-something'"
echo "If it 'freezes', you will need 'xf86-input-libinput'."
echo
echo "For advanced users:"
echo
echo "The source code itself is in $spde/programname."
echo "You must recompile it by running 'make install' after performing changes!"
echo
echo "If you enjoy this install script, consider supporting me by donating some Monero."
echo "The address is here: https://speedie.gq/donate.html"
echo
echo "Have a good day!"

exit 0
