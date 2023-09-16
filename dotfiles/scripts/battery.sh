#!/bin/sh

while true; do
    # Obtener el estado de la batería y el nivel de carga
    estado=$(acpi -b | awk '{print $3}' | sed 's/,$//')
    nivel_carga=$(acpi -b | grep -Eo "[0-9]+%" | grep -Eo "[0-9]+")

    if [ $estado == "Discharging" ] && [ $nivel_carga -eq 10 ]; then
        dunstify -a "Bateria baja" -i /home/jose/.config/scripts/icons/battery-empty.svg "Nivel de bateria: $nivel_carga%"
        canberra-gtk-play -i dialog-error -d "error"
    fi

    if [ $estado == "Discharging" ] && [ $nivel_carga -eq 20 ]; then
        echo "pff tiramos de bateria, conectameeeee"
        dunstify -a "Bateria baja" -i /home/jose/.config/scripts/icons/battery-quarter-solid.svg "Nivel de bateria: $nivel_carga%"
        canberra-gtk-play -i dialog-error -d "error"
    fi

    if [ $estado == "Charging" ] && [ $nivel_carga -eq 100 ]; then
        dunstify -a "Bateria cargada" -i /home/jose/.config/scripts/icons/battery-full-solid.svg "Bateria cargada completamente"
        canberra-gtk-play -i dialog-error -d "error"
    fi
    # Esperar un tiempo antes de volver a verificar (ajusta el tiempo como desees)
    sleep 120  # 120 segundos
done