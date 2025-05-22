#!/bin/bash

id=$1

# DATOS ESENCIALES PARA LA CREACIÓN DE LA INSTANCIA
curl -s http://localhost:4000/councils/$1 > datos.json
nombre=$(jq -r .name datos.json)
puerto1=$(jq -r .puerto_org datos.json)
puerto2=$(jq -r .puerto_proc_part datos.json)
logo=$(jq -r .logo_url datos.json)
banner=$(jq -r .banner_url datos.json)
colab=$(jq -r .collaborations datos.json)
servicios=$(jq -r .services datos.json)

