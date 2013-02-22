require 'open311_helper'

describe "RequestsController", :type => :feature do
  describe "GET new" do
    context "with invalid service" do
      it "raises routing error" do
        expect { visit request_path('one_service') }.to raise_exception(ActionController::RoutingError)
      end
    end

    context "with a valid service" do
      def stub_service(attributes)
        RequestsController.any_instance.stub(:service) do
          FactoryGirl.build(:open311_service, :attrs => attributes)
        end
      end

      after(:each) { RequestsController.any_instance.unstub(:service) }

      it "has input type text for string" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "desc", :datatype => "string"),
        ])
        visit request_path('one_service')
        page.should have_selector('#request_desc[type=text]')
      end

      it "has textarea input for text" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "desc", :datatype => "text"),
        ])
        visit request_path('one_service')
        page.should have_selector('textarea#request_desc')
      end

      it "has multiple select for datetime input" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "time", :datatype => "datetime"),
        ])
        visit request_path('one_service')
        (1..3).each { |i| page.should have_selector("select#request_time_#{i}i") }
      end

      it "has input type number for number" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "amount", :datatype => "number"),
        ])
        visit request_path('one_service')
        page.should have_selector('#request_amount[type=number]')
      end

      it "has input select for singlevaluelist" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "category", :datatype => "singlevaluelist",
                            :values => [{ 'key' => 'key1', 'name'  => 'Key one' },
                                        { 'key' => 'key2', 'name'  => 'Key two' }])
        ])
        visit request_path('one_service')
        page.should have_selector('select#request_category')
      end

      it "has multiple checkboxes for multiplevaluelist" do
        stub_service([
          FactoryGirl.build(:open311_attribute, :code => "tags", :datatype => "multiplevaluelist",
                            :values => [{ 'key' => 'key1', 'name'  => 'Key one' },
                                        { 'key' => 'key2', 'name'  => 'Key two' }]),
        ])
        visit request_path('one_service')
        (1..2).each { |i| page.should have_selector("#request_tags_key#{i}[type=checkbox]") }
      end

      it "submits and creates a request" do
        stub_service [
          FactoryGirl.build(:open311_attribute, :code => "grapher", :datatype => "string")
        ]

        RailsOpen311.stub(:api_wrapper) do
          wrapper = Open311::ApiWrapper.from_url('http://dummy.dev', 'key')
          double('Open311::ApiWrapper').tap do |test_double|
            test_double.should_receive(:send_request).once()
          end
        end

        visit request_path('one_service')
        fill_in "request_grapher", :with => 'Tony Hawks'
        click_button "request_submit"
        current_path.should == services_path
        page.should have_selector('.flash-notice')
      end

    end
  end
end
