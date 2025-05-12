class StopCouncilService
  def initialize(council)
    @council = council
  end

  def call
    Rails.logger.info "Parando #{@council.name}"
    sleep(1)
  end
end