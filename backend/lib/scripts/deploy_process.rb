# lib/scripts/deploy_process.rb
council = Council.find(ARGV[0])
org = Decidim::Organization.first

process = Decidim::ParticipatoryProcess.create!(
  organization: org,
  title: council.name,
  description: "Creado desde backend para #{council.name}",
  start_date: Date.today,
  end_date: 1.year.from_now,
  published_at: Time.zone.now
)

process.logo.attach(council.logo.blob) if council.logo.attached?
process.hero_image.attach(council.banner.blob) if council.banner.attached?

council.update(decidim_process_id: process.id)
puts "Proceso creado con ID #{process.id}"
