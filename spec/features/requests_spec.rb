require 'open311_helper'

describe "RequestsController", :type => :feature do
  describe "GET new" do
    context "with invalid service" do
      it "raises routing error" do
        visit '/'
        expect { visit request_path('one_service') }.to raise_exception(ActionController::RoutingError)
      end
    end

    context "with a valid service" do
      before(:each) do
        RequestsController.any_instance.stub(:service) do
          service = Open311::Service.new(min_sample_service)
          service.attrs = [
            Open311::Attribute.new(one_attribute.update("code" => "desc", "type" => "textarea")),
            Open311::Attribute.new(one_attribute.update("code" => "phone", "type" => "text")),
          ]
          service
        end
      end

      after(:each) { RequestsController.any_instance.unstub(:service) }

      it "returns a form with one field per attr" do
        visit request_path('one_service')
        within '#new_open311_service' do
          page.should have_selector('.control-group', :count => 2)
        end
      end

    end
  end
end
