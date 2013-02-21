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
    attribute :attrs, :default => []

    def ordered_attrs
      attrs.sort_by(&:order)
    end

    def to_param
      service_code
    end

    def to_post_params
      keys = [
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

      params = {}

      keys.map do |key|
        value = self[key]
        if value
          params[key] = value
        end
      end

      params
    end
  end

end
