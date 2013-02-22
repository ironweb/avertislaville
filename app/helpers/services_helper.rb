module ServicesHelper

  def service_config(code)
    RailsOpen311.load_config['services'].select do |section|
      section['service_code'] == code
    end.first || {}
  end

  def service_name(service)
    config = service_config(service.code)
    if config.include? 'name'
      config['name']
    else
      service.name
    end
  end

  def service_css_class(service)
    config = service_config(service.code)
    return config['css_class'] if config.include? 'css_class'
    return service.name.parameterize
  end

  def service_desc(service)
    config = service_config(service.code)
    return config['description'] if config.include? 'description'
    return service.description
  end

end
