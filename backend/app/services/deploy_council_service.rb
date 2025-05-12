class DeployCouncilService
  def initialize(council)
    @council = council
    @organization = Decidim::Organization.first
  end

  def call
    return unless @organization

    process = Decidim::ParticipatoryProcess.create!(
      organization: @organization,
      title: @council.name,
      description: "Proceso automático para #{@council.name}",
      start_date: Time.zone.today,
      end_date: 1.year.from_now,
      published_at: Time.zone.now
    )

    # Asociar logo y banner
    process.logo.attach(@council.logo.blob) if @council.logo.attached?
    process.hero_image.attach(@council.banner.blob) if @council.banner.attached?

    # Guardar el ID del proceso en el council
    @council.update(decidim_process_id: process.id)
  end
end
