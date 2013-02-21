require_dependency 'open311'
module RailsOpen311

  CONFIG_PATH = "#{Rails.root}/config/open311.yml"
  CACHE_KEY = 'open311_services'

  def self.load_config
    YAML.load_file(CONFIG_PATH)
  end

  def self.load_all_services!
    api_config = load_config

    url = api_config['url']

    url = api_config['url']
    jurisdiction_id = api_config['jurisdiction_id']

    api_wrapper = Open311::ApiWrapper.from_url(url, jurisdiction_id)
    services = api_wrapper.services_with_attrs

    Rails.cache.write CACHE_KEY, services
  end

  def self.all_services
    Rails.cache.read(CACHE_KEY) || load_all_services!
  end

  def self.filtered_services
    api_config = load_config
    groups = api_config['groups']
    return all_services.select { |s| groups.include? s.group }
  end

end
