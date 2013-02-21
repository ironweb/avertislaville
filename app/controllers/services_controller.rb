class ServicesController < ApplicationController
  def index
    @services = RailsOpen311.filtered_services
  end
end
