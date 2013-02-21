module Open311

  class Service

    attr_reader :name
    attr_reader :code
    attr_reader :group
    attr_reader :description
    attr_reader :metadata
    attr_reader :type

    def initialize(data)
      @name = data['service_name']
      @code = data['service_code']
      @group = data['group']
      @description = data['description']
      @metadata = data['metadata']
      @type = data['type']
    end

  end

end
