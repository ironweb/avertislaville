require 'rest-client'
require 'json'

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

end


class Service
  attr_reader :name
  attr_reader :code
  attr_reader :group
  attr_reader :description
  attr_reader :metadata
  attr_reader :type

  def initialize(data)
    @name = data['service_name']
    @code = data['service_code']
    @group = data['group']
    @description = data['description']
    @metadata = data['metadata']
    @type = data['type']
  end

end
