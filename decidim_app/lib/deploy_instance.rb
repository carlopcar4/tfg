# lib/deploy_instance.rb
require "net/http"
require "uri"
require "json"

class DeployInstance
  def self.create(id, locale = :es)
    uri  = URI("http://172.17.0.1:4000/councils/#{id}")
    data = JSON.parse(Net::HTTP.get(uri))
    name = data["name"]

    tn = { locale => name }                    # traducciones

    org = Decidim::Organization.create!(
      name:              tn,
      description:       { locale => "Organización de prueba para #{id}" },
      reference_prefix:  name[0,3].upcase,    # <- nuevo (p.e. “BAR”)
      host:              "#{name.parameterize}.localhost",
      available_locales: [locale],
      default_locale:    locale
    )

    Decidim::ParticipatoryProcess.create!(
      organization:      org,
      title:             tn,
      subtitle:          { locale => "Subtítulo para #{name}" },
      short_description: { locale => "Resumen breve para #{name}" },
      description:       { locale => "Proceso participativo para #{name}" },
      slug:              name.parameterize,
      private_space:     false,
      published_at:      Time.current
    )
  end
end
