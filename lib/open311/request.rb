module Open311

  class Request
    include ActiveAttr::Model

    attribute :service_code
    attribute :description
    attribute :lat
    attribute :long
    attribute :email
    attribute :device_id
    attribute :account_id
    attribute :first_name
    attribute :last_name
    attribute :phone
    attribute :description
    attribute :media_url
    attribute :attrs, :default => {}

    def ordered_attrs
      attrs.sort_by(&:order)
    end

    def to_param
      service_code
    end

    def to_post_params
      params = attributes.reject { |k,v| v.nil? }
      extra_attrs = params.delete('attrs')
      extra_attrs.each do |key, value|
        param_key = "attribute[#{key}]"
        params[param_key] = value
      end
      params
    end
  end

end
