class RequestsController < ApplicationController
  before_filter :validate_service, :only => [:new, :create]

  def new
    @request = Request.new(service)
  end

  def create
    @request = Request.new(service)
    @request.attributes = params[:request].except("password")
    if true # TODO : request.valid?
      # TODO : Create db record in transaction
      api_wrapper = RailsOpen311.api_wrapper
      api_response = api_wrapper.send_request(@request)

      if api_response.valid?
        notice = I18n.t('request.success')
      else
        notice = api_response.error_message
      end
      redirect_to services_path, :notice =>I18n.t('request.success')
    else
      render 'new'
    end
  end

  private

  def validate_service
    unless service
      raise ActionController::RoutingError.new("Invalid service : #{params[:service]}")
    end
  end

  def service
    @service ||= RailsOpen311.filtered_services.find do |service|
      service.code == params[:service]
    end
  end
end
