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
        event = create_event(api_response)
        if event.save!
          redirect_to services_path, :notice => I18n.t('request.success')
          return
        else
          flash.now[:alert] = I18n.t('request.error')
        end
      else
        flash.now[:alert] = api_response.error_message
      end
    end
    render 'new'
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

  def create_event(api_response)
    Event.from_request(@request).tap do |event|
      event.token = api_response.token
    end
  end
end
