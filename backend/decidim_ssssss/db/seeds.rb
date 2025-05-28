# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# You can remove the 'faker' gem if you do not want Decidim seeds.
Decidim.seed!


nombre = ENV.fetch('NOMBRE')
host = "#{nombre}.localhost:#{ENV.fetch("PUERTO1")}"
prefijo = ENV.fetch("NOMBRE_DOCKER")[0,3]
logo_url = ENV.fetch('LOGO_URL')
banner_url = ENV.fetch('BANNER_URL')

org = Decidim::Organization.find_or_initialize_by(host: host)
org.assign_attributes(
  name: nombre,
  available_locales: [:es],
  default_locale: :es,
  reference_prefix: prefijo
)
org.save! if org.changed?
puts "organización creada/cambiada"

require "open-uri"

unless org.logo.attached?
  io=URI.open(logo_url)
  org.logo.attach(io:io, filename: "logo#{io.content_type.split('/').last}")
  puts "logo adjuntado"
end

unless org.highlighted_content_banner_image.attached?
  io=URI.open(banner_url)
  org.highlighted_content_banner_image.attach(io:io, filename: "banner#{io.content_type.split('/').last}")
  puts "banner adjuntado"
end

admin_attrs = { email: "admin#admin.org" }
admin = Decidim::System::Admin.find_or_initialize_by(admin_attrs)
if admin.new_record?
  admin.password  = admin.password_confirmation = "contraseña123"
  admin.save!
  puts "admin creado"
end

proc = Decidim::ParticipatoryProcess.find_or_initialize_by(slug: "proceso-inicial", organization: org)
if proc.new_record?
  proc. title = { es: "Proceso inicial"}
  proc.subtitle = { es: "Subtítulo de ejemplo" }
  proc.description = { es: "Descripción de prueba" }
  proc.private_space = false
  proc.save!
  puts "proceso creado"
end

page = Decidim::StaticPage.find_or_initialize_by(slug: "home", organization: org)
if page.new_record?
  page.title = { es: "Inicio" }
  page.content = { es: "<h1>Bienvenido</h1><p>Esta es tu nueva plataforma.</p>" }
  page.save!
  puts "página estática creada"
end

