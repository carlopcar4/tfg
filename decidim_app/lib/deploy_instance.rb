class DeployInstance
  puts "Script cargado correctamente"


  def self.create(name)
    org = Decidim::Organization.first

    Decidim::ParticipatoryProcess.create!(
      organization: org,
      title: { es: name, en: name },
      subtitle: { es: "Subtítulo para #{name}", en: "Subtitle for #{name}" },
      short_description: { es: "Resumen breve para #{name}", en: "Short summary for #{name}" },
      slug: name.parameterize,
      description: { es: "Proceso participativo para #{name}", en: "Participatory process for #{name}"},
      scope: org.scopes.first,
      private_space: false,
      published_at: Time.current
    )
  end
end