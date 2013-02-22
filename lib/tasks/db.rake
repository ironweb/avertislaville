namespace :db do
  def random_lat
    Random.rand(46.777493..46.873336)
  end

  def random_lon
    Random.rand(-71.351051..-71.213722)
  end

  desc "Add samples to play with the application"
  task :sample => :environment  do
    type_codes = RailsOpen311.filtered_services.map(&:code)
    12.times do
      Event.create(lonlat: "POINT(#{random_lon} #{random_lat})",
                   type_code: type_codes.sample)
    end
  end
end

