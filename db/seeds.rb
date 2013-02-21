# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def run_sql_seed(file)
  file = File.join("#{Rails.root}", 'db', 'seeds', file)
  ActiveRecord::Base.connection.execute(IO.read(file))
end
run_sql_seed('areas.sql')
run_sql_seed('districts.sql')
