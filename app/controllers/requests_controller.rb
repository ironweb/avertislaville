class RequestsController < ApplicationController
  before_filter :validate_service, :only => [:new, :create]

  def new
    @request = Easy311::Request.new(service)
  end

  def create
    @request = Easy311::Request.new(service)
    @request.attributes = params[:request].except("password")

    if @request.valid?
      api_wrapper = Easy311::Rails.api_wrapper
      api_response = api_wrapper.send_request(@request)

      if api_response.invalid?
        flash.now[:alert] = api_response.error_message
        render 'new' and return
      end

      event = create_event(api_response)
      if event.save
        redirect_to(services_path, :notice => I18n.t('requests.success')) and return
      else
        flash.now[:alert] = I18n.t('requests.error') # TODO hard error message + log
      end
    else
      flash.now[:alert] = I18n.t('requests.errors_in_form')
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
    @service ||= Easy311::Rails.filtered_services.find do |service|
      service.code == params[:service]
    end
  end

  def create_event(api_response)
    Event.from_request(@request).tap do |event|
      event.token = api_response.token
    end
  end
end
