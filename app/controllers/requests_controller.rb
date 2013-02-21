class RequestsController < ApplicationController
  before_filter :validate_service, :only => [:new]

  def new
    @service = service
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
