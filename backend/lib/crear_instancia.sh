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
    colab=$(jq -r '.collaborations | join(",")' datos.json)
    servicios=$(jq -r '.services | join(",")' datos.json)
    echo "Avanzando un poco más"

# ESTO ES PARA PRUEBA
    rm -rf /home/carlos/TFG/"decidim_$nombre"

# CREACIÓN DE LA INSTANCIA
    cp -r /home/carlos/TFG/decidim_base/prueba/ /home/carlos/TFG/"decidim_$nombre"

# CREACIÓN DE .ENV
    cd /home/carlos/TFG/"decidim_$nombre"/
    touch .env
    echo "NOMBRE=$nombre" > .env
    echo "PUERTO1=$puerto1" >> .env
    echo "LOGO=$logo" >> .env
    echo "BANNER=$banner" >> .env
    echo "COLAB=$colab" >> .env
    echo "SERVICIOS=$servicios" >> .env

    docker-compose --env-file .env up -d

