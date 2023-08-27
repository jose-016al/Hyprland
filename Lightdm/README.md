- **[Personalizar LightDM](https://geekland.eu/personalizar-y-configurar-lightdm/)**

Copiamos el fichero de configuracion de lightdm-gtk-greeter a la ruta /eta/lighttdm, desde este archivo podremos modificar toda la personalizacion del tema del gestor de arranque
```bash
sudo cp -r lightdm-gtk-greeter.conf /etc/lightdm/
```
Para cambiar el fondo de pantalla de bloqueo , copiaremos la imagen a un directorio concreto, es importante que la imgagen se llame "wallpaperBloqueo.jpg"
```bash
sudo cp -r ../.screenshots/wallpaperBloqueo.jpg /usr/share/pixmaps/
```
Para cambiar el icono debemos seleccionar la imagen y copiarla en la ruta anterior, esta imagen se puede llamar "face", si no queremos moidifcar el fichero
```bash
sudo cp -r ~/face.png /usr/share/pixmaps/
```