module ServicesHelper

  def service_config(code)
    RailsOpen311.load_config['services'].select do |section|
      section['service_code'] == code
    end.first || {}
  end

  def service_name(service)
    config = service_config(service.code)
    return config['name'] if config.include? 'name' else service.name
  end

  def service_css_class(service)
    config = service_config(service.code)
    return config['css_class']
  end

end
