require 'rest-client'
require 'json'
require 'pp'

URL = "http://dev-api.ville.quebec.qc.ca/open311/v2"

puts "getting services"
resource = RestClient::Resource.new URL
response = resource['/services.json'].get
services = JSON.parse(response)
first_service = services.first

data = {
  :service_code => first_service[:service_code],
  :lat => 12.23,
  :long => 23.45,
}

