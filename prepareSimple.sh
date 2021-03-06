apt-get update
# apt upgrade 
apt-get install -y -q --no-install-recommends libgtkglext1 libpango1.0-0 libpangox-1.0-0 libgtk2.0-0 

TURBOVNC_VERSION=2.2.5
LIBJPEG_VERSION=2.0.6
NOVNC_VERSION=1.2.0
WEBSOCKIFY_VERSION=0.9.0
ANYDESK_VERSION=6.0.1-1

CWD=$(pwd)
mkdir -p /opt

# TurboVNCanydesk
cd /tmp
curl -fsSL -O https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb
curl -fsSL -O https://sourceforge.net/projects/libjpeg-turbo/files/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb
curl -fsSL -O https://download.anydesk.com/linux/anydesk_${ANYDESK_VERSION}_amd64.deb
dpkg -i *.deb
sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
rm -f /tmp/*.deb

# noVNC
curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt 
curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt 
rm -rf /opt/noVNC
mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC
rm -rf /opt/websockify
mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify
ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html
cd /opt/websockify
make  > /dev/null
mv rebind.so websockify

# X11 
apt-get install -y -q  \
        ca-certificates \
        vim.tiny \
        nano \
        libc6-dev \
        libglu1 \
        libsm6 \
        libxv1 \
        x11-xkb-utils \
        x11-xserver-utils \
        x11-utils \
        xauth \
        xfonts-base \
        xkb-data \
        scrot \
        xterm \
        xvfb \
        x11vnc \
        xtightvncviewer \
        mesa-utils \
        python-opengl \
        openbox \
        xfce4 \
        xfce4-goodies \
        gvfs libgail-common libgtk2.0-bin \
        onboard \
    > /dev/null
    
cd ${CWD}

# Web ブラウザ（Epiphany）
add-apt-repository -r -y ppa:gnome3-team/gnome3 > /dev/null
add-apt-repository -y ppa:gnome3-team/gnome3 > /dev/null
apt-get -q -y install epiphany-browser > /dev/null

# Ngrok
mkdir -p /content/.vnc
curl -fsSL -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip -d /opt ngrok-stable-linux-amd64.zip
rm ngrok-stable-linux-amd64.zip 
echo "web_addr: 4045" > /content/config.yml

# Xmodmap
cat << EOS > ~/.Xmodmap
keycode 111 = Up
keycode 116 = Down
keycode 113 = Left
keycode 114 = Right
EOS
