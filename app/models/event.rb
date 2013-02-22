class Event < ActiveRecord::Base
  validates :type_code, :presence => true, :inclusion => { :in =>
    proc { RailsOpen311.filtered_services.map(&:code) } }

  attr_accessible :type_code, :lonlat

  def lat
    lonlat.try(:y)
  end

  def lon
    lonlat.try(:x)
  end

end
