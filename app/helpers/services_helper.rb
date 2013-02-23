module ServicesHelper

  def service_config(code)
    Easy311::Rails.load_config['services'].select do |section|
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

  def service_input(form, code, attr)
    html = form.input(attr.code.to_sym,
      :label => attr.description,
      :placeholder => attr.description,
      :as => "easy311_#{attr.datatype}",
      :collection => attr.values,
      :label_method => lambda { |v| v['name'] },
      :value_method => lambda { |v| v['key'] },
      :required => attr.required,
      :input_html => { value: nil })

    #TODO: Find a cleaner way of deactivating the input than just hiding and submitting
    if prefill_date_input(code)
      return "<div class='hidden'>#{html}</div>".html_safe
    end
    return html
  end

  def prefill_date_input(code)
    Easy311::Rails.load_config['date_prefill'].include? code
  end

end
