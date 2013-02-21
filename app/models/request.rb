require 'active_support/core_ext/hash/indifferent_access'
class Request
  include ActiveAttr::Model

  attr_reader :service
  attr_writer :attrs_values

  def initialize(service)
    @attrs_values = ActiveSupport::HashWithIndifferentAccess.new
    @service = service
  end

  def attributes
    super.merge(Hash[service.attrs.map { |k, v| [k.to_sym, self.send(k)] }])
  end

  def method_missing(method, *args, &block)
    attr_name = method.to_s.gsub(/=$/, '')
    if service.attrs.has_key?(attr_name)
      if method.to_s.match(/=$/)
        @attrs_values[attr_name] = args.first
      else
        @attrs_values[attr_name]
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
