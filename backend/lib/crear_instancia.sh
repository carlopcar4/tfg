#!/bin/bash

id=$1

function datos() {
    cd /home/carlos/TFG/backend/lib
    curl -s http://localhost:4000/councils/$1 > datos.json
    ./acentos.sh datos.json
    n=$(jq -r .name datos.json)
    nom="${n// /-}"
    nombre="${nom,,}"
    nombre_docker="${nombre//-/_}"
    puerto1=$(jq -r .puerto_org datos.json)
    puerto2=$(jq -r .puerto_proc_part datos.json)
    logo=$(jq -r .logo_url datos.json)
    banner=$(jq -r .banner_url datos.json)
    colab=$(jq -r '.collaborations | join(",")' datos.json)
    servicios=$(jq -r '.services | join(",")' datos.json)
}

function crear_carpeta() {
    cd /home/carlos/TFG
    rm -rf "decidim_$nombre"
    cp -r decidim_base "decidim_$nombre"
    cd "decidim_$nombre"
    nombre_docker="${nombre//-/_}"
    touch .env
    echo "NOMBRE=$nombre" > .env
    echo "nombre_docker=${nombre//-/_}" >> .env
    echo "PUERTO1=$puerto1" >> .env
    echo "LOGO=$logo" >> .env
    echo "BANNER=$banner" >> .env
    echo "COLAB=$colab" >> .env
    echo "SERVICIOS=$servicios" >> .env
    echo "DATABASE_URL=postgres://postgres:postgres@pg:5432/decidim_${nombre_docker}" >> .env
}

function crear_docker() {
    docker-compose --env-file .env down --remove-orphans
    docker-compose --env-file .env up -d
    docker exec -it decidim_${nombre_docker}_app_1 bundle exec rails db:create
    docker exec -it decidim_${nombre_docker}_app_1 bundle exec rails db:migrate
}

datos $id 
crear_carpeta
crear_docker
