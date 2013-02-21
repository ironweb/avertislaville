module RailsOpen311

  CONFIG_PATH = "#{Rails.root}/config/open311.yml"
  CACHE_KEY = 'open311_services'

  def self.load_all_services
    api_config = YAML.load_file(CONFIG_PATH)

    api_wrapper = Open311::ApiWrapper.from_url(api_config['url'])
    services = api_wrapper.services_with_attributes

    Rails.cache.write CACHE_KEY, services

  end

end

RailsOpen311.load_all_services
