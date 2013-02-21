require 'rest-client'
require 'json'
require 'open311/service'
require 'open311/attribute'

module Open311

  class ApiWrapper

    def self.from_url(url)
      resource = RestClient::Resource.new(url)
      return self.new(resource)
    end

    def initialize(resource)
      @resource = resource
    end

    def all_services
      response = @resource['/services.json'].get.strip
      return [] if response.empty?

      raw_services = JSON.parse(response)
      services = raw_services.map { |r| Service.new(r) }

      return services
    end

    def group_names
      all_services.map { |s| s.group }.uniq
    end

    def groups
      all_services.group_by { |s| s.group }
    end

    def attrs_from_code(code)
      response = @resource["/services/#{code}.json"].get.strip
      return [] if response.empty?

      json_data = JSON.parse(response)
      raw_attrs = json_data['attributes']
      return [] if raw_attrs.empty?

      attrs = raw_attrs.map { |a| Attribute.new(a) }

      return attrs
    end

    def services_with_attrs
      services = all_services.map do |service|
        service.attrs = attrs_from_code(service.code)
        service
      end
      return services
    end

  end

end
