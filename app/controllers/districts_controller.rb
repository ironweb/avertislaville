class DistrictsController < ApplicationController

  def index
    @districts = District.all
  end

  def scores
    @districts = District.all
  end

end
