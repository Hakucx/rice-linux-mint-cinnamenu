#!/bin/bash

# Comprobación de permisos
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root con sudo."
   exit 1
fi

echo "Actualizando sistema..."
apt update && apt upgrade -y

echo "Instalando paquetes necesarios..."
apt install -y lm-sensors psensor conky-all plank git curl unzip fonts-ubuntu cinnamon-common papirus-icon-theme

echo "Detectando sensores..."
yes | sensors-detect > /dev/null

echo "Configurando directorios..."
USER_HOME="/home/$SUDO_USER"
mkdir -p "$USER_HOME/.config/conky"
cp .conkyrc "$USER_HOME/.conkyrc"
chown $SUDO_USER:$SUDO_USER "$USER_HOME/.conkyrc"

echo "Aplicando fondo de pantalla..."
mkdir -p "$USER_HOME/.local/share/backgrounds"
cp wallpaper.jpg "$USER_HOME/.local/share/backgrounds/wallpaper.jpg"
gsettings set org.cinnamon.desktop.background picture-uri "file://$USER_HOME/.local/share/backgrounds/wallpaper.jpg"

echo "Activando Conky al inicio..."
mkdir -p "$USER_HOME/.config/autostart"
cat > "$USER_HOME/.config/autostart/conky.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=conky -p 5
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky
EOL
chown -R $SUDO_USER:$SUDO_USER "$USER_HOME/.config"

echo "Instalando Cinnamenu..."
cinnamon-spices install applets cinnamenu@cinnamenu

echo "Listo. Reiniciá tu sesión para aplicar todos los cambios."
