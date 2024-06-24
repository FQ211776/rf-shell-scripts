#!/bin/bash

function color_echo() {
    local text=""
    local bold=0  # Usamos 0 para "no negrita" y 1 para "negrita"

    for arg in "$@"; do
        case $arg in
            -b|--bold)   bold=1 ;;
            -rb|--reset-bold) bold=0 ;; 
            -c|--cyan)       text+="\033[${bold};96m" ;; # Cyan (bold opcional)
            -m|--magenta)    text+="\033[${bold};95m" ;; # Magenta (bold opcional)
            -g|--green)      text+="\033[${bold};92m" ;; # Green (bold opcional)
            -r|--red)        text+="\033[${bold};91m" ;; # Red brillante (mejor contraste)
            -y|--yellow)     text+="\033[${bold};93m" ;; # Yellow (bold opcional)
            -bl|--blue)      text+="\033[${bold};94m" ;; # Blue (bold opcional)
            -w|--white)      text+="\033[${bold};97m" ;; # White (bold opcional)
            -o|--orange)     text+="\033[${bold};38;5;208m" ;; # Orange brillante (256 colores)
            -p|--purple)     text+="\033[${bold};38;5;93m" ;; # Purple (256 colores)
            *) text+="$arg " ;; # Texto normal
        esac
    done

    echo -e "$text\033[0m" # Restablecer estilo y color al final
}


# Ejemplos de uso:
color_echo -c "Este texto es" -b -r "rojo brillante y en negrita"
color_echo -y "Texto amarillo" -g "y verde" -o "con un toque de naranja"
color_echo -b -p "Texto morado en negrita"

color_echo -c "Este" -b -r "es" -g "un" -y "ejemplo" -o "con" -p "muchos" -bl "colores" -w "y negrita"


color_echo -c "Este" -b -r "es" -g "un" -w "ejemplo" -o "con" -p "muchos" -w "colores" -y "y negrita"
