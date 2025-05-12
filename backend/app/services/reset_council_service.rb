class ResetCouncilService
  def initialize(council)
    @council = council
  end

  def call
    Rails.logger.info "Reinicio de #{@council.name}"
    sleep(2)
  end
end
