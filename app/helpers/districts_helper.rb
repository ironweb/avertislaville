module DistrictsHelper
  def service_score(district, service)
    points = RailsOpen311.points_for_area(district.name)
    nb_events = Event.where(:type_code => service.code).count()
    return nb_events * points
  end

  def total_district_score(district, services)
    services.map { |s| service_score(district, s) }.sum
  end
end
