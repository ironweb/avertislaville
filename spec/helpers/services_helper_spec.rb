require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ServicesHelper. For example:
#
# describe ServicesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ServicesHelper do

  service = Struct.new(:code, :name).new("servicecode", "Service Name")

  describe "service name" do

    it "generates service name from metadata" do
      config = {
        'services' => [{
          'service_code' => "servicecode",
          'name' => "Trottoir a reparer",
        }]
      }
      RailsOpen311.stub(:load_config).and_return(config)

      name = service_name(service)
      name.should == "Trottoir a reparer"
    end

    it "uses service name when no metadata" do
      config = {'services' => []}
      RailsOpen311.stub(:load_config).and_return(config)

      name = service_name(service)
      name.should == service.name
    end

  end

  describe "service css class" do

    it "generates service css class from metadata" do
      config = {
        'services' => [{
          'service_code' => "servicecode",
          'css_class' => 'cssclass',
        }]
      }
      RailsOpen311.stub(:load_config).and_return(config)

      css_class = service_css_class(service)
      css_class.should == 'cssclass'
    end

  end

end
