Para personalizr el tema del grub, nos dirigimos a **[Gnome-Look](https://www.gnome-look.org/s/Gnome/browse/)** y nos descargamos el tema que mas nos guste  
Lo copiamos a la ruta /usr/share/grub/themes
```bash
sudo cp -r starfield /usr/share/grub/themes/
```
Una vez hayamos copiado el tema a la ruta tendremos que especificarlorlo en el fichero de grub
```bash
sudo nano /etc/default/grub
```
Y modificamos la linea grub_theme
```bash
GRUB_THEME="/usr/share/grub/themes/starfield/theme.txt"
```
Para finalizar tendremos que actualizar la configuracion de grub
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
