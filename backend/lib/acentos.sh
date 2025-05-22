#!/bin/bash
if [ "--help" = "$1" ] || [ "0" = "$#" ]
then
    echo
    echo "Uso:"
    echo "       acentos < archivo1 archivo2 ... archivoN >"
    echo
    exit 0
fi

until [ -z "$1" ]
do
    archivo="$1"
    if [ -f "$archivo" ]
    then
        cp "$archivo" "${archivo}.bak"
        cat "${archivo}.bak" | sed -e 's/á/a/g' \
-e 's/é/e/g' \
-e 's/í/i/g' \
-e 's/ó/o/g' \
-e 's/ú/u/g' \
-e 's/Á/A/g' \
-e 's/É/E/g' \
-e 's/Í/I/g' \
-e 's/Ó/O/g' \
-e 's/Ú/U/g'  > "$archivo"
    else
        if [ -d "$archivo" ]
        then
            echo "$archivo: Es un directorio"
        else
            echo "$archivo: Archivo no existente"
        fi
    fi
    shift
done