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
    docker exec -it decidim_${nombre_docker}_pg_1 psql -U postgres -c "DROP DATABASE IF EXISTS decidim_${nombre_docker}"
    docker-compose --env-file .env down --remove-orphans
    docker-compose --env-file .env up -d
    docker exec -it decidim_${nombre_docker}_app_1 bundle exec rails db:create
    docker exec -it decidim_${nombre_docker}_app_1 bundle exec rails db:migrate
}

function crear_organizacion() {

    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
organizacion = Decidim::Organization.create!(
    name: "$nombre" ,
    host: "${nombre}.localhost:$puerto1",
    available_locales: [:es],
    default_locale: :es,
    reference_prefix: "${nombre_docker:0:3}"
)
puts "Organización creada"
EOF


    host_ip=$(docker exec -i tfg_backend_1 ip route | awk '/default/ { print $3 }')
    logo_url_sustituido=$(echo "$logo" | sed "s|localhost:4000|$host_ip:4000|g")
    docker exec -i decidim_${nombre_docker}_app_1 curl -L -o /tmp/logo.png "$logo_url_sustituido"

    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
org = Decidim::Organization.last
org.logo.attach(
    io: File.open("/tmp/logo.png"),
    filename: "logo.png",
    content_type: "image/png"
)
org.save!
puts "Logo adjuntado"
EOF

    banner_url_sustituido=$(echo "$banner" | sed "s|localhost:4000|$host_ip:4000|g")
    docker exec -i decidim_${nombre_docker}_app_1 curl -L -o /tmp/banner.jpg "$banner_url_sustituido"

    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
org = Decidim::Organization.last
org.highlighted_content_banner_image.attach(
    io: File.open("/tmp/banner.jpg"),
    filename: "lobannergo.jpg",
    content_type: "image/jpg"
)
org.save!
puts "banner adjuntado"
EOF


    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
admin = Decidim::System::Admin.new(
    email: "admin@admin.org",
    password: "contraseña123",
    password_confirmation: "contraseña123"
)
admin.save!
puts "Usuario creado"
EOF



    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
org=Decidim::Organization.last
process = Decidim::ParticipatoryProcess.create!(
    organization: org, 
    title: { es: "hola" }, 
    subtitle: { es: "hola" }, 
    description: { es: "hoa" }, 
    slug: "sde", 
    short_description: { es: "hoa" },
    private_space: false
)
puts "Proceso creado"
EOF

    docker exec -i decidim_${nombre_docker}_app_1 bundle exec rails runner - <<EOF
org=Decidim::Organization.last
pag = Decidim::StaticPage.create!(
    organization: org, 
    title: { es: "Inicio" }, 
    slug: "home", 
    content: { es: "<h1>Bienvenido a la plataforma</h1><p>Esta es la portada.</p>" },


)

puts "Proceso creado"
EOF



}




datos $id 
crear_carpeta
crear_docker
crear_organizacion
