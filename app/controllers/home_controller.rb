class HomeController < ApplicationController
  def home
    @events = Event.where('created_at > ? ', 7.days.ago).to_json(methods: [:lat, :lon], only: [])
  end
end
