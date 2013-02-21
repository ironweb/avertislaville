require 'rest-client'
require 'json'
require 'pp'

URL = "http://dev-api.ville.quebec.qc.ca/open311/v2"

puts "getting services"
resource = RestClient::Resource.new URL
response = resource['/services.json'].get
services = JSON.parse(response)
first_service = services.first

puts "getting attributes"
code = first_service['service_code']
response = resource["/services/#{code}.json"].get
attributes = JSON.parse(response)
pp attributes
