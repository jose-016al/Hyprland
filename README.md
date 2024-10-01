# ArchLinux & Hyprland 2.0


Sin intalamos hyprland desde el script de archinstall, se nos instalaran los siguientes paquetes

hyprland, kitty, wofi, qt5-wayland, dunst, dolphin, xsg-desktop-portal-hyprland, qt5-wayland

Instalacion manual 

Para poder instalar hyprland necesitamos yay
```bash 
git clone https://aur.archlinux.org/yay.git
```
```bash
cd yay
```
```bash
makepkg -si # si este comando no va necesitaremos instalar base-devel por medio de pacman
```

yay -S hyprland kitty brave-bin wofi




















![Hyprland](.screenshots/hyprland.png)

# Otras opciones de entorno de escritorio

Además de Hyprland, hay varios otros entornos de escritorio populares disponibles para Arch Linux. Si estás interesado en explorar otras opciones, aquí tienes una recomendación:

## Qtile

[Qtile](http://www.qtile.org/) es un gestor de ventanas dinámico para X11 que se configura completamente en Python. Es ligero y altamente personalizable, lo que lo convierte en una excelente opción para aquellos que prefieren un entorno de escritorio más minimalista.

Si deseas explorar la configuración personalizada de Qtile, echa un vistazo a mis [dotfiles](https://github.com/jose-016al/Qtile). de Qtile en GitHub.

# Tabla de contenidos
- [ArchLinux](#arch-linux)
  - [Instalacion de ArchLinux](#instalacion-de-archlinux)
    - [Definir la distribución de teclado y fuente en consola](#definir-la-distribución-de-teclado-y-fuente-en-consola)
    - [Conexion wifi](#conexion-wifi)
    - [Particiones y formato de disco](#particionar-y-formatear-el-disco)
    - [Instalar paquetes esenciales](#instalar-paquetes-esenciales)
    - [Configuración del sistema](#configuración-del-sistema)
    - [Instalacion del gestor de arranque](#instalacion-del-gestor-de-arranque)
    - [Finalización](#finalización)
  - [Configuracion adicional de Arch Linux](#configuracion-adicional-de-arch-linux)
- [Hyprland](#hyprland)
  - [Instalacion de Hyprland](#instalacion-de-hyprland)
  - [Instalacion y config automatica](#instalacion-y-config-automatica)
  - [Instalacion paquetes necesarios para Hyprland](#instalacion-paquetes-necesarios-para-hyprland)
  - [Mi configuracion](#mi-configuracion)
  - [Creditos](#creditos)

# Enlaces a consultar
- **[Wine](https://dev.to/yofreormaza/instalar-wine-en-arch-linux-4bok)**
- **[Gnome-Look](https://www.gnome-look.org/s/Gnome/browse/)**
- **[Hyprland docs](https://hyprland.org/)**
- **[Mejorar los mirrors](https://salmorejogeek.com/2016/11/18/usando-reflector-para-descargar-mas-rapido-de-los-mirros-de-arch-antergos/)**
- **[Nerd Fonts](https://www.nerdfonts.com/cheat-sheet)**
- **[Instalar Docker](https://linuxhint.com/arch-linux-docker-tutorial/)**
- **[Problemas con las llaves](https://superlativoblog.wordpress.com/2017/01/06/solucion-al-problema-de-llaves-actualizando-arch-o-derivadas/)**
- **[Screen Sharing](https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/)**
- **[Virtual maquines](https://platzi.com/tutoriales/2383-prework-linux/21080-instalacion-de-virtualbox-en-archlinux/)**

# Arch Linux

## Instalacion de ArchLinux 
Debido a que la instalación puede variar, lo más recomendable es dirigirnos directamente a la [guide installation](https://wiki.archlinux.org/title/Installation_guide_(Espa%C3%B1ol)) y seguirla paso a paso para Arch Linux.  

### Definir la distribución de teclado y fuente en consola
Para configurar la distribucion de teclado en español
```bash
loadkeys es
```
Es posible que el tamaño de la fuente sea demasiado pequeño. Por ahora, podemos ajustar esto utilizando el siguiente comando:  
```bash
setfont ter-118n
```

### Conexion wifi
```bash
iwctl
```
```bash
station wlan0 scan       
```
```bash
station wlan0 get-networks
```
```bash
station wlan0 connect SSID
```

### Particionar y formatear el disco
Optaremos por utilizar cfdisk debido a su facilidad de uso  
```bash
cfdisk
```
Particionamos el disco utilizando cfdisk de la siguiente manera:  
  - 150 MB - EFI SYSTEM
  - 15 GB - SWAP
  - Resto del espacio - /  
Para ver las particiones fuera de cfdisk, podemos utilizar el siguiente comando:  
```bash
lsblk
```
Procedemos a formatear la partición SWAP
```bash
mkswap /dev/sda2
```
```bash
swapon /dev/sda2
```
Procedemos a formatear la partición ROOT
```bash
mkfs.ext4 /dev/sda3
```  
Procedemos a montar los sistemas de archivos  
```bash
mount /dev/sda3 /mnt
```
Montamos la partición EFI  
```bash
mount --mkdir /dev/sda1 /mnt/boot
```

### Instalar paquetes esenciales
```bash
pacstrap /mnt base base-devel linux linux-firmware linux-headers mkinitcpio networkmanager sudo grub efibootmgr nano iwd git
```

### Configuración del sistema
Generamos un archivo fstab que contiene las particiones del sistema, utilizando UUID para montarlas automáticamente al inicio  
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
Cambiamos el entorno de trabajo al sistema instalado en /mnt, permitiendo realizar configuraciones como si estuviéramos en el sistema recién instalado   
```bash
arch-chroot /mnt
```
Creamos un enlace simbólico a la zona horaria deseada, configurando la hora local del sistema  
```bash
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
```
Sincronizamos el reloj de hardware con la hora del sistema, asegurando que ambos estén alineados  
```bash
hwclock --systohc
```
Abrimos el archivo de configuración de locales en el editor nano, donde se pueden activar los idiomas deseados  
```bash
nano /etc/locale.gen
```
Generamos los locales especificados en el archivo /etc/locale.gen, permitiendo la utilización de diferentes idiomas y formatos regionales  
```bash
locale-gen
```
Establecemos el idioma predeterminado del sistema, configurando la variable de entorno LANG a español  
```bash
echo LANG=es_ES.UTF-8 > /etc/locale.conf
```
Crea el archivo vconsole.conf para establecer el mapa de teclado en español 
```bash
nano KEYMAP=es > /etc/vconsole.conf
```
Definimos el nombre del host del sistema, que se utilizará en la red 
```bash
echo ArchLinux > /etc/hostname
```
Cambiamos la contraseña del usuario root, asegurando el acceso seguro al sistema  
```bash
passwd
```
Cremaos un usuario
```bash
useradd -m -g users -G wheel -s /bin/bash jose  
```
```bash
passwd
```
Añadimos al usuario al archivo de sudoers  
```bash
nano /etc/sudoers
```
Asegurarse de habilitar el servicio networkManager
```bash
systemctl enable NetworkManager
```

### Instalacion del gestor de arranque
Instalamos GRUB en modo EFI y asigna "Arch" como identificador del cargador de arranque  
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch
```
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
```
Generamos el archivo de configuración de GRUB  
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Finalización
Reiniciamos el sistema, y si aparece el gestor de arranque de Arch, todo habrá salido correctamente.
```bash
umount -R /mnt
```
```bash
reboot
```
Ahora creamos las carpetas personales básicas (Escritorio, Descargas, Música, etc.). Para ello, instalamos la herramienta xdg-user-dirs:  
```bash
sudo pacman -S xdg-user-dirs
```
Finalmente, lo ejecutamos para generar nuestras carpetas  
```bash
xdg-user-dirs-update
```

# Hyprland

## Instalacion y config automatica
Podemos ejecutar el script "install.sh", si deseamos hacer la instalacion de todos los paquetes necesarios de forma automatica y copiar los dotfiles
```bash
./install.sh
```
Posteriormente a esto haremos un reinicio, si decidimos realizar el script ya habremos terminado

## Instalacion de Hyprland
Para poder instalar hyprland necesitamos yay
```bash 
git clone https://aur.archlinux.org/yay.git
```
```bash
cd yay
```
```bash
makepkg -si # si este comando no va necesitaremos instalar base-devel por medio de pacman
```
Instalamos Qtile y el logging manager
```bash
yay -S hyprland kitty brave-bin
```
```bash
sudo pacman -S sddm
```
```bash
systemctl enable sddm
```

## Instalacion paquetes necesarios para Hyprland
Una vez ya este instalado hyprland, ya podremos instalar los paquetes que necesitamos (algunos de estos paquetes no son necesarios)
```bash
sudo pacman -S rofi waybar unzip pavucontrol pamixer xautolock hyprpaper nemo cinnamon-translations grim slurp swappy dunst zsh bat lsd neofetch wget udisks2 udiskie ntfs-3g vlc network-manager-applet spotify-launcher pacman-contrib 
```
```bash
yay -S sddm-theme-sugar-candy-git wl-clip-persist swaylock-effects xviewer zsh-syntax-highlighting zsh-autosuggestions nwg-look telegram-desktop visual-studio-code-bin autofirma configuradorfnmt onedriver xfce4-power-manager gnome-disk-utility evince whatsapp-for-linux light transmission-cli burpsuite
```

## Mi configuracion
Para mantener la misma configracion del entorno de escritorio
```bash
git clone git@github.com:jose-016al/Hyprland.git
```
```bash
cd Hyprland
```
Copiamos el directorio .config
```bash
cp -r dotfiles ~/
```

## Creditos 
<p>Agradecimientos a @<a href="https://github.com/f3l3p1n0">f3l3p1n0</a> por los dotfiles iniciales. Mi trabajo se basa en sus contribuciones.</p>
<p><a href="https://github.com/f3l3p1n0/bluehypr">BlueHypr - f3l3p1n0</a></p>
