class District < ActiveRecord::Base
  include ContainsPoint

  def all_services
    events = Event.select(:type_code).where(:district_id => id).group(:type_code)
    events.map { |e| Easy311::Rails.filtered_services.find { |s| s.code == e.type_code } }.uniq
  end

end
