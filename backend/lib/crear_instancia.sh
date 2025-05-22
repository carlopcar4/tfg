#!/bin/bash

id=$1

# DATOS ESENCIALES PARA LA CREACIÓN DE LA INSTANCIA
    curl -s http://localhost:4000/councils/$1 > datos.json
    ./acentos.sh datos.json
    n=$(jq -r .name datos.json)
    nom="${n// /-}"
    nombre="${nom,,}"
    puerto1=$(jq -r .puerto_org datos.json)
    puerto2=$(jq -r .puerto_proc_part datos.json)
    logo=$(jq -r .logo_url datos.json)
    banner=$(jq -r .banner_url datos.json)
    colab=$(jq -r .collaborations datos.json)
    servicios=$(jq -r .services datos.json)
    echo "Avanzando un poco más"

crear_instancia() {
    if [ -d /home/carlos/TFG/"decidim_$nombre" ]
    then
        echo "El directorio para la instancia $nombre ya existe"
    else
        cp -r /home/carlos/TFG/decidim_base/prueba/ /home/carlos/TFG/"decidim_$nombre"
    fi
}
crear_instancia