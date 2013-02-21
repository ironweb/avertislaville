require 'rest-client'
require 'json'
require 'open311/service'
require 'open311/attribute'

module Open311

  class ApiWrapper

    def self.from_url(url, api_key, jurisdiction_id=nil)
      resource = RestClient::Resource.new(url)
      return self.new(resource, jurisdiction_id)
    end

    def initialize(resource, api_key, jurisdiction_id=nil)
      @resource = resource
      @api_key = api_key
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

    def send_request(request)
      params = request.to_post_params
      params['api_key'] = @api_key
      @resource['/requests.json'].post(params) do |response|
        if response.code.to_i >= 400
          return parse_error_response(response.body)
        end
        return parse_post_response(response.body)
      end
    end

    def parse_post_response(body)
      json_response = JSON.parse(body)
      return Response.new(json_response)
    end

    def parse_error_response(body)
      json_response = JSON.parse(body)
      response = Response.new
      response.error_message = json_response.map { |r| r['description'] }.join(",")
      return response
    end

  end

end
