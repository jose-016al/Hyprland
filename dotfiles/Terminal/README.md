# Configuracion kitty
Si tenemos problemas con el teclado en español
```bash
localectl set-x11-keymap es
```
Cambiamos la shell
```bash
sudo usermod --shell /bin/zsh jose 
```
Creamos un directorio en la ruta
```bash
sudo mkdir /usr/share/zsh-sudo
```
```bash
sudo cp -r sudo.plugin.zsh /usr/share/zsh-sudo
```
Clonamos el repositorio de powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
```
```bash
zsh 
```
```bash
cp -r .p10k.zsh ~/
```
Copiamos el archivo de configuracion de zsh
```bash
cp -r .zshrc ~/
```
