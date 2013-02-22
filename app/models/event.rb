class Event < ActiveRecord::Base
  validates :type_code, :presence => true, :inclusion => { :in =>
    proc { RailsOpen311.filtered_services.map(&:code) } }

  validates :lonlat, presence: true

  attr_accessible :type_code, :lonlat

  before_save :set_district
  before_save :set_area

  def lat
    lonlat.try(:y)
  end

  def lon
    lonlat.try(:x)
  end


  private

  def set_district
    self.district = District.contains_point(lat, lon)
  end

  def set_area
    self.district = Area.contains_point(lat, lon)
  end

end
