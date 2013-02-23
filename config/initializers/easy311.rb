module Easy311
  module Rails

    def self.filtered_services
      api_config = load_config
      grouped_services = Hash[all_services.map { |s| [s.code, s] }]
      return api_config['services'].map do |metadata|
        code = metadata['service_code']
        grouped_services[code]
      end
    end

    def self.points_for_area(area)
      load_config['scoring'][area] || 1
    end

    def self.filtered_services
      api_config = load_config
      grouped_services = Hash[all_services.map { |s| [s.code, s] }]
      return api_config['services'].map do |metadata|
        code = metadata['service_code']
        grouped_services[code]
      end
    end

  end
end

