describe Event do
  describe "#validates" do
    it "is only valid with application keys" do
      filtered_return = [double('Service').tap { |d| d.stub(:code).and_return('CODE123') }]
      RailsOpen311.stub(:filtered_services).and_return(filtered_return)

      Event.new.valid?.should be_false
      Event.new(type_code: 'ABC').valid?.should be_false
      Event.new(type_code: 'CODE123').valid?.should be_true
    end

    after(:each) { RailsOpen311.unstub(:filtered_services) }
  end

  it "has `x` and `y` method to map for lat/lon" do
    event = Event.new(lonlat: "POINT(2 44)")
    event.lat.should == 44
    event.lon.should == 2
  end
end
