require 'rest-client'
require 'json'
require 'open311/service'
require 'open311/attributes'

module Open311

  class ApiWrapper

    def self.from_uri(uri)
      resource = RestClient::Resource.new(uri)
      return self.new(resource)
    end

    def initialize(resource)
      @resource = resource
    end

    def services
      response = @resource['/services.json'].get.strip
      return [] if response.empty?

      raw_services = JSON.parse(response)
      services = raw_services.map { |r| Service.new(r) }

      return services
    end

    def group_names
      services.map { |s| s.group }.uniq
    end

    def groups
      services.group_by { |s| s.group }
    end

    def attributes_from_code(code)
      response = @resource["/services/#{code}.json"].get.strip
      return [] if response.empty?

      json_data = JSON.parse(response)
      raw_attributes = json_data['attributes']
      return [] if raw_attributes.empty?

      attributes = raw_attributes.map { |a| Attribute.new(a) }

      return attributes
    end

  end

end
