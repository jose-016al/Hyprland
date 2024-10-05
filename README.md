# ArchLinux & Hyprland

![Hyprland](dotfiles/.screenshots/hyprland2.gif)

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
  - [Atajos de teclado](#atajos-de-telcado)
    - [Sistema](#sistema)
    - [Focus](#focus)
    - [Move](#move)
    - [Resize](#resize)
  - [Creditos](#creditos)
- [Mejorar los mirrrorlist](#mejorar-los-mirrorlist)
- [Instalar Docker](#instalar-docker)
- [Instalar Virtual Box](#instalar-virtual-box)
- [KeePass](#keepass)
- [Compartir pantalla](#compartir-pantalla)

# Enlaces a consultar
- **[Wine](https://dev.to/yofreormaza/instalar-wine-en-arch-linux-4bok)**
- **[Gnome-Look](https://www.gnome-look.org/s/Gnome/browse/)**
- **[Hyprland docs](https://hyprland.org/)**
- **[Nerd Fonts](https://www.nerdfonts.com/cheat-sheet)**
- **[Problemas con las llaves](https://superlativoblog.wordpress.com/2017/01/06/solucion-al-problema-de-llaves-actualizando-arch-o-derivadas/)**

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
  - 300 MB - EFI SYSTEM
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
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
```
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --removable
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
Podemos ejecutar el script "install.sh" para instalar automáticamente todos los paquetes necesarios y copiar los archivos de configuración (dotfiles). Para hacerlo, simplemente ejecuta el siguiente comando:  
```bash
./install.sh
```
Una vez completada la ejecución, será necesario reiniciar el sistema para aplicar todos los cambios. Después de esto, la instalación estará finalizada  

## Atajos de telcado
A continuación se presentan los atajos de teclado configurados en mis dotfiles para facilitar el uso y la navegación. La tecla mod corresponde a la tecla de Windows:  

### Sistema
| Acción                        | Atajo                                   |
|-------------------------------|-----------------------------------------|
| **mod + ENTER**               | Abre una terminal (Kitty)               |
| **mod + E**                   | Abre el explorador de archivos (Nemo)   |
| **mod + M**                   | Abre el lanzador de aplicaciones (Rofi) |
| **mod + B**                   | Abre el navegador web (Brave)           |
| **mod + C**                   | Abre el editor de código (VS Code)      |
| **mod + S**                   | Realiza una captura de pantalla         |
| **mod + L**                   | Bloquea el escritorio (Swaylock)        |
| **mod + W**                   | Cierra la ventana activa                |
| **mod + F**                   | Convierte una ventana a flotante        |
| **mod + Space**               | Pone la ventana en pantalla completa    |

### Focus
| Acción                        | Atajo                        |
|-------------------------------|------------------------------|
| **mod + H**                   | Mueve el foco a la izquierda |
| **mod + L**                   | Mueve el foco a la derecha   |
| **mod + K**                   | Mueve el foco a la arriba    |
| **mod + J**                   | Mueve el foco a la abajo     |

### Move
| Acción                        | Atajo                           |
|-------------------------------|---------------------------------|
| **mod + ALT + H**             | Mueve la ventana a la izquierda |
| **mod + ALT + L**             | Mueve la ventana a la derecha   |
| **mod + ALT + K**             | Mueve la ventana a la arriba    |
| **mod + ALT + J**             | Mueve la ventana a la abajo     |

### Resize
| Acción                        | Atajo                                             |
|-------------------------------|---------------------------------------------------|
| **mod + SHIFT + LEFT**        | Redimensiona la ventana activa hacia la izquierda |
| **mod + SHIFT + RIGHT**       | Redimensiona la ventana activa hacia la derecha   |
| **mod + SHIFT + UP**          | Redimensiona la ventana activa hacia arriba       |
| **mod + SHIFT + DOWN**        | Redimensiona la ventana activa hacia abajo        |

## Creditos 
<p>Agradecimientos a @<a href="https://github.com/f3l3p1n0">f3l3p1n0</a> por los dotfiles iniciales. Mi trabajo se basa en sus contribuciones.</p>
<p><a href="https://github.com/f3l3p1n0/bluehypr">BlueHypr - f3l3p1n0</a></p>

# Mejorar los mirrorlist
Este proceso optimiza los servidores de espejo (mirrors) utilizados por pacman para mejorar la velocidad y eficiencia de las descargas de paquetes. A continuación, los pasos para actualizar tu lista de servidores:  
```bash
sudo pacman -S reflector rsync
```
```bash
sudo reflector --verbose -l 10 --sort rate --save /etc/pacman.d/mirrorlist
```

# Instalar Docker
Instalar Docker  
```bash
sudo pacman -S docker
```
Habilitar el servicio de Docker  
```bash
sudo systemctl enable docker.service
```
Añadir tu usuario al grupo de Docker  
```bash
sudo usermod -aG docker $USER
```
Para más información sobre Docker y su uso, puedes consultar mi repositorio de [Dcoker](https://github.com/jose-016al/Docker)

# Instalar Virtual Box
Instalar VirtualBox  
```bash
sudo pacman -S virtualbox
```
Instalar los encabezados del núcleo LTS  
```bash
sudo pacman -S  linux-lts-headers
```
Cargar los módulos de VirtualBox  
```bash
sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci
```
Añadir tu usuario al grupo vboxusers  
```bash
sudo gpasswd -a $USER vboxusers
```
Instalar las herramientas de invitado de VirtualBox  
```bash
sudo pacman -S virtualbox-guest-iso
```

# KeePass
- [Keepass RPC](https://github.com/kee-org/keepassrpc/releases/tag/v2.0.2): Permite el autocompletado automático de contraseñas en el navegador  
- [Kee - Password Manager](https://chromewebstore.google.com/detail/kee-password-manager/mmhlniccooihdimnnjhamobppdhaolme?hl=es&pli=1) Extensión para autocompletado en Google Chrome  
- [Yet Another Favicon Downloader](https://github.com/navossoc/KeePass-Yet-Another-Favicon-Downloader/releases/tag/v1.2.5.0): Permite descargar íconos para personalizar nuestra base de datos  
- [KeeTheme](https://github.com/xatupal/KeeTheme/releases/tag/v0.10.7) Añade un nuevo tema oscuro a KeePass para una mejor experiencia visual  
- [Paquetes de idioma](https://keepass.info/translations.html) Permite agregar tu idioma a KeePass para una experiencia más personalizada  

Instalar KeePass usando Yay  
```bash
yay -S keepass
```
Descomprimir el archivo del idioma español  
```bash
unzip KeePass-2.57-Spanish.zip
```
Crear el directorio para los idiomas  
```bash
sudo mkdir /usr/share/keepass/Languages 
```
Mover el archivo del idioma español al directorio correspondiente  
```bash
mv Spanish.lngx /usr/share/keepass/Languages
```
Mover los plugins necesarios a la carpeta de plugins de KeePass  
```bash
sudo mv KeePassRPC.plgx YetAnotherFaviconDownloader.plgx KeeTheme.dll KeeTheme.plgx /usr/share/keepass/Plugins  
```

# Compartir pantalla 
Para habilitar el uso de la función de compartir pantalla en tu entorno, simplemente instala los siguientes paquetes. La configuración necesaria ya está incluida en los dotfiles para que funcione correctamente:  
```bash
sudo pacman -S pipewire wireplumber xdg-desktop-portal-hyprland
```
Si algo no funciona como se espera o deseas más información, puedes consultar la documentación oficial sobre [Screen Sharing](https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/)