class ServicesController < ApplicationController
  def index
    @services = Easy311::Rails.filtered_services
  end
end
