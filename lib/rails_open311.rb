require_dependency 'open311'
module RailsOpen311

  CONFIG_PATH = "#{Rails.root}/config/open311.yml"
  CACHE_KEY = 'open311_services'

  def self.load_config
    YAML.load(ERB.new(IO.read(CONFIG_PATH)).result)
  end

  def self.load_all_services!
    api_wrapper = self.api_wrapper
    services = api_wrapper.services_with_attrs

    Rails.cache.write CACHE_KEY, services
  end

  def self.all_services
    Rails.cache.read(CACHE_KEY) || load_all_services!
  end

  def self.filtered_services
    api_config = load_config
    grouped_services = Hash[all_services.map { |s| [s.code, s] }]
    return api_config['services'].map do |metadata|
      code = metadata['service_code']
      grouped_services[code]
    end
  end

  def self.api_wrapper
    api_config = load_config
    url = api_config['url']
    jurisdiction_id = api_config['jurisdiction_id']
    api_key = api_config['apikey']

    Open311::ApiWrapper.from_url(url, api_key, jurisdiction_id)
  end

  def self.points_for_area(area)
    load_config['scoring'][area] || 1
  end

end
