require 'rest-client'
require 'json'
require 'open311/service'
require 'open311/attribute'

module Open311

  class ApiWrapper

    def self.from_url(url, jurisdiction_id=nil)
      resource = RestClient::Resource.new(url)
      return self.new(resource, jurisdiction_id)
    end

    def initialize(resource, jurisdiction_id=nil)
      @resource = resource
      @jurisdiction_id = jurisdiction_id
    end

    def all_services
      response = query_service('/services.json')
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
      url = "/services/#{code}.json"
      response = query_service(url)
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

    def query_service(path)
      params = build_params
      response = @resource[path].get(params)
      return response.strip
    end

    def build_params
      params = {}
      params[:jurisdiction_id] = @jurisdiction_id unless @jurisdiction_id.nil?
      return params
    end

  end

end
