#!/bin/bash
updates=$(checkupdates 2>/dev/null | wc -l)
echo "$updates"  # Esto muestra el número de actualizaciones pendientes con un icono
