class DeployCouncilService
  def initialize(council)
    @council = council
  end

  def call
    command = "docker exec tfg_decidim_1 rails runner \"require '/app/lib/deploy_instance.rb'; DeployInstance.create('#{@council.name}')\""
    
    if system(command)
      @council.update(status: "running")
    else
      Rails.logger.error "Error al crear el proceso participativo para #{@council.name}"
    end
  end
end
