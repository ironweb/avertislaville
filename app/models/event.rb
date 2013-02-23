class Event < ActiveRecord::Base
  validates :type_code, :presence => true, :inclusion => { :in =>
    proc { Easy311::Rails.filtered_services.map(&:code) } }

  validates :lonlat, presence: true

  attr_accessible :type_code, :lonlat

  before_save :set_district
  before_save :set_area

  belongs_to :district
  belongs_to :area

  def self.from_request(request)
    event = Event.new(
      :lonlat => "POINT(#{request.long.to_f} #{request.lat.to_f})",
      :type_code => request.service.code
    )
  end

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
    self.area = Area.contains_point(lat, lon)
  end

end
