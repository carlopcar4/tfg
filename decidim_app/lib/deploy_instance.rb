require "net/http"
require "uri"
require "json"

class DeployInstance
  def self.create(id, locale = :es)
    uri  = URI("http://172.17.0.1:4000/councils/#{id}")
    data = JSON.parse(Net::HTTP.get(uri))
    name = data["name"]
    logo = data["logo_url"]
    banner = data["banner_url"]

    tn = { locale => name }                

    org = Decidim::Organization.first()
    if org.nil?
      org = Decidim::Organization.create!(
      name:              tn,
      description:       { locale => "Organización de prueba para #{id}" },
      reference_prefix:  name[0,3].upcase,    # <- nuevo (p.e. “BAR”)
      host:              "#{name.parameterize}.localhost",
      available_locales: [locale],
      default_locale:    locale
    )
    end

    if logo.present?
      org.logo.attach(
        io: URI.open(logo),
        filename: "logo_#{name}.png"
      )
    end

    process = Decidim::ParticipatoryProcess.create!(
      organization:      org,
      title:             tn,
      subtitle:          { locale => "Subtítulo para #{name}" },
      short_description: { locale => "Resumen breve para #{name}" },
      description:       { locale => "Proceso participativo para #{name}" },
      slug:              name.parameterize,
      private_space:     false,
      published_at:      Time.current,
    )

    
    if banner.present?
      org.highlighted_content_banner_title = { "es" => "Participación abierta" }
      org.highlighted_content_banner_short_description = { "es" => "Haz oír tu voz" }
      org.highlighted_content_banner_action_title = { "es" => "Participa ahora" }
      org.highlighted_content_banner_action_subtitle = { "es" => "Participa ahora" }
      org.highlighted_content_banner_action_url = "https://#{org.host}"
      org.highlighted_content_banner_image.attach(
        io: URI.open(banner),
        filename: "banner.jpg"
      )
      org.highlighted_content_banner_enabled = true
      org.save!

      process.banner_image = banner
      # process.hero_image.attach(
      #   io: URI.open(banner),
      #   filename: "banner.jpg"
      # )
      process.save!

    end
  end
end