module Open311

  class Service
    include ActiveAttr::Model

    attribute :name
    attribute :code
    attribute :group
    attribute :description
    attribute :metadata
    attribute :type
    attribute :attrs, :default => []

    def service_name=(value)
      self.name = value
    end

    def service_code=(value)
      self.code = value
    end

    def to_param
      code
    end
  end

end
