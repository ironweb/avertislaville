require 'active_support/core_ext/hash/indifferent_access'
module Open311
  class Request
    include ActiveAttr::Model

    attribute :description
    attribute :email
    attribute :first_name
    attribute :last_name
    attribute :phone
    attribute :password
    attribute :lat
    attribute :long
    attribute :device_id
    attribute :account_id
    attribute :media_url

    attr_reader :service
    attr_accessor :attrs_values

    POST_KEYS = [
      :service_code,
      :description,
      :lat,
      :long,
      :email,
      :device_id,
      :account_id,
      :first_name,
      :last_name,
      :phone,
      :description,
      :media_url,
    ]

    def initialize(service)
      @attrs_values = ActiveSupport::HashWithIndifferentAccess.new
      @service = service
    end

    def attributes
      super.merge("attrs" => Hash[service.attrs.map { |k, v| [k.to_s, self.send(k)]}])
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

    def to_post_params
      params = attributes.select { |k,v| !v.nil? and POST_KEYS.include? k.to_sym }
      params['service_code'] = @service.code if @service.code

      attrs_values.each do |key, value|
        param_key = "attribute[#{key}]"
        params[param_key] = value
      end

      params
    end
  end
end
