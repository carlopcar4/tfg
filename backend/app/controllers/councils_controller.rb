class CouncilsController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :verify_authenticity_token

  def index
    @councils = Council.all
    render json: @councils
  end

  def show
    @council = Council.find(params[:id])
    if @council.logo.attached? and  @council.banner.attached?
      logo_url = url_for(@council.logo)
      banner_url = url_for(@council.banner)
      t = @council.as_json.merge(logo_url: logo_url, banner_url: banner_url)
      render json: t, status: :accepted
    else
      render json: @council
    end
  end


  def create
    @council = Council.new(council_params)
    @council.logo.attach(params[:logo])
    @council.banner.attach(params[:banner])

    if @council.save
      DeployCouncilService.new(@council).call
      if @council.logo.attached? and  @council.banner.attached?
        logo_url=url_for(@council.logo)
        banner_url=url_for(@council.banner)
        t = @council.as_json.merge(logo_url: logo_url, banner_url: banner_url)
        # system("bash #{Rails.root}/lib/crear_instancia.sh #{@council.id}")

        render json: t, status: :created
      else
        render json: @council, status: :created
      end
    else
      render json: @council.errors, status: :unprocessable_entity
    end
  end


  def update
    begin
      @council = Council.find(params[:id])
      if @council.update(params.permit(:name, :province, :population, :multi_tenant, collaborations: [], services: []))
        render json: @council, status: :ok
      else 
        render json: @council, status: :no_content
      end
    rescue Exception => e
      Rails.logger.error(e)
      render json: @council.errors, status: :bad_request
    end
  end


  def deploy
    @council = Council.find(params[:id])
    if ['stopped', 'pending'].include?(@council.status)
      begin
        DeployCouncilService.new(@council).call
        @council.update(status: 'running')
        render json: {message: "Desplegado correctamente"}
      rescue Exception => e
        Rails.logger.error(e)
        render json: @council.errors, status: :bad_request
      end
    else
      begin
        StopCouncilService.new(@council).call
        @council.update(status: 'stopped')
        render json: {message: "Instancia parada correctamente"}
      rescue Exception => e
        Rails.logger.error(e)
        render json: @council.errors, status: :bad_request
      end
    end
  end

  def reset
    @council = Council.find(params[:id])
    if ['running'].include?(@council.status)
      begin
        ResetCouncilService.new(@council).call
        render json: {message: "Reinicio completado"}
      rescue Exception => e
        Rails.logger.error(e)
        render json: @council.errors, status: :bad_request
      end
    end
  end


  def destroy
    @council = Council.find(params[:id])
    if @council.destroy
      render json: {message: "Municipio eliminado correctamente" }
    else
      render json: @council.errors, status: :not_found
    end
  end

  private

  def council_params
    params.permit(:name, :province, :population, :puerto_org, :puerto_proc_part, :multi_tenant, collaborations: [], services: [])
  end


end
