module ContainsPoint
  extend ActiveSupport::Concern
  module ClassMethods
    def contains_point(lat, long)
      where("ST_Contains(geom, ST_MakePoint(?, ?))", long, lat).first
    end
  end
end
