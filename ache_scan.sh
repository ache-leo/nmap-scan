#!/bin/bash

check_nmap_installed() {
    if ! command -v nmap &> /dev/null; then
        echo "Nmap no está instalado. Por favor, instálalo antes de ejecutar este script."
        exit 1
    fi
}

validate_ip() {
    local ip=$1
    if [[ ! $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "La dirección IP ingresada no es válida."
        exit 1
    fi
}

menu() {
    echo "Menú de opciones:"
    echo "1. Escanear mi red"
    echo "2. Escanear puertos de una IP específica (rápido y ruidoso)"
    echo "3. Escanear puertos de una IP específica (normal)"
    echo "4. Escanear puertos de una IP específica (silencioso)"
    echo "5. Salir"
}

scan_my_network() {
    echo "Escaneando mi red..."
    nmap -sn 192.168.1.0/24  # Cambia la dirección de red según tu configuración
}

scan_ports_fast_noisy() {
    echo "Introduce la IP a escanear:"
    read ip
    validate_ip $ip
    echo "Escaneando puertos de $ip de manera rápida y ruidosa..."
    nmap -T4 -A $ip
}

scan_ports_normal() {
    echo "Introduce la IP a escanear:"
    read ip
    validate_ip $ip
    echo "Escaneando puertos de $ip de manera normal..."
    nmap -sS -T4 $ip
}

scan_ports_silent() {
    echo "Introduce la IP a escanear:"
    read ip
    validate_ip $ip
    echo "Escaneando puertos de $ip de manera silenciosa..."
    nmap -sS -T4 -Pn $ip
}

handle_error() {
    local error_message=$1
    echo "Error: $error_message"
    exit 1
}

trap 'handle_error "Se ha producido un error inesperado."' ERR

check_nmap_installed

while true; do
    menu
    read -p "Seleccione una opción (1-5): " choice
    case $choice in
        1) scan_my_network ;;
        2) scan_ports_fast_noisy ;;
        3) scan_ports_normal ;;
        4) scan_ports_silent ;;
        5) echo "Saliendo..."; break ;;
        *) echo "Opción inválida. Inténtalo de nuevo." ;;
    esac
done

