#!/bin/bash

id=$1

function datos() {
    cd /app/lib
    curl -s http://backend:4000/councils/$1 | tee datos.json

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
    cd /app
    rm -rf "decidim_$nombre"
    cp -r decidim_base "decidim_$nombre"
    cd "decidim_$nombre"
    nombre_docker="${nombre//-/_}"
    touch .env
    echo "nombre=$nombre" > .env
    echo "nombre_docker=${nombre//-/_}" >> .env
    echo "puerto1=$puerto1" >> .env
    echo "logo=$logo" >> .env
    echo "banner=$banner" >> .env
    echo "colab=$colab" >> .env
    echo "servicios=$servicios" >> .env
    echo "database_url=postgres://postgres:postgres@pg:5432/decidim_${nombre_docker}" >> .env
}

function crear_docker() {
    cd /app/decidim_$nombre
    docker exec decidim_${nombre_docker}_pg_1 psql -U postgres -c "DROP DATABASE IF EXISTS decidim_${nombre_docker}"
    docker-compose --env-file .env down --remove-orphans
    docker-compose --env-file .env up -d
    docker exec decidim_${nombre_docker}_app_1 bundle exec rails db:create
    docker exec decidim_${nombre_docker}_app_1 bundle exec rails db:migrate
}

datos $id 
crear_carpeta
crear_docker