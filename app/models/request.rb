class Request
  include ActiveAttr::Model

  attr_reader :service

  def initialize(service)
    @service = service
  end

  def method_missing(method, *args, &block)
    attr_name = method.to_s.gsub(/=$/, '')
    if service.attrs.has_key?(attr_name)
      if method.to_s.match(/=$/)
        attributes[attr_name] = *args
      else
        attributes[attr_name]
      end
    else
      super
    end
  end

  def respond_to?(method)
    if service.attrs.has_key?(method.to_s.gsub(/=$/, ''))
      true
    else
      super
    end
  end
end
