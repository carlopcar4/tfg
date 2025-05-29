# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


nombre = ENV.fetch('NOMBRE')
host = "#{nombre}.localhost:#{ENV.fetch("PUERTO1")}"
prefijo = ENV.fetch("NOMBRE_DOCKER")[0,3]
logo_url = ENV.fetch('LOGO')
banner_url = ENV.fetch('BANNER')

org = Decidim::Organization.create!(
  name: { es: "${nombre}" }, 
  description: { es: "Organización de #{nombre}" },
  reference_prefix: prefijo,
  host: host,
  available_locales: [ :es ],
  default_locale: :es
)
puts "organización creado"

proc = Decidim::ParticipatoryProcess.create!(
  organization: org,
  title: { es: "#{nombre}" },
  subtitle: { es: "Subtítulo de #{nombre}" },
  short_description: { es: "Resumen de #{nombre}" },
  description: { es: "Descripción de #{nombre}" },
  private_space: false,
  published_at: Time.now,
  slug: "#{nombre}",
  start_date: Time.zone.today,
  end_date: Time.zone.today + 30.days
)
puts "proceso participativo creado"

org.logo.attach(io: File.open("/tmp/logo.png"), filename: "logo_#{nombre}")
puts "logo adjunto"
org.highlighted_content_banner_image.attach(io: File.open("/tmp/banner.png"), filename: "banner_#{nombre}")
org.highlighted_content_banner_enabled = true
org.highlighted_content_banner_title = { es: "Bienvenido a #{nombre}" }
org.highlighted_content_banner_short_description = { es: "Descripción de #{nombre}" }
org.highlighted_content_banner_action_title = { es: "¡Participa!" }
org.highlighted_content_banner_action_url = "https://#{host}/participa"
org.save!
puts "banner adjunto"

admin = Decidim::System::Admin.new(
  email: "admin@admin.org",
  password: "contraseña123",
  password_confirmation: "contraseña123"
)
admin.save!
puts "admin creado"

pagina = Decidim::StaticPage.create!(
  organization: org,
  title: { es: "Página de inicio" },
  content: { es: "<h1>Bienvenido</h1><p>Esta es tu nueva plataforma.</p>" },
  slug: "home",
  allgow_public_access: true,
  show_in_footer: true
)
pagina.save!