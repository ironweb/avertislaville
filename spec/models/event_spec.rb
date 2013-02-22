describe Event do
  describe "#validates" do
    describe "application key" do
      after(:each) { RailsOpen311.unstub(:filtered_services) }

      it "is required and valid only if code is in config" do
        filtered_return = [double('Service').tap { |d| d.stub(:code).and_return('CODE123') }]
        RailsOpen311.stub(:filtered_services).and_return(filtered_return)

        Event.new.valid?.should be_false

        invalid_type = Event.new(type_code: 'ABC')
        invalid_type.valid?.should be_false
        invalid_type.errors.should have_key(:type_code)

        valid_type = Event.new(type_code: 'ABC')
        valid_type.errors.should_not have_key(:type_code)
      end
    end

    it "requires lonlat" do
      without_lonlat = Event.new
      without_lonlat.valid?.should be_false
      without_lonlat.errors.should have_key(:lonlat)
    end
  end

  it "has `x` and `y` method to map for lat/lon" do
    event = Event.new(lonlat: "POINT(2 44)")
    event.lat.should == 44
    event.lon.should == 2
  end

  describe "#from_request" do

    context "minimal request" do

      request = FactoryGirl.build(:open311_request)

      subject do
        filtered_return = [double('Service').tap { |d| d.stub(:code).and_return(request.service.code) }]
        RailsOpen311.stub(:filtered_services).and_return(filtered_return)
        event = Event.from_request(request)
        event.save
        event
      end

      it("has a latitude")  { subject.lat.should_not be_nil }
      it("has a longitude") { subject.lon.should_not be_nil }
      it("has a type code") { subject.type_code.should_not be_nil }
      it("has the same latitude as request")    { subject.lat.should == request.lat }
      it("has the same longitude as request")   { subject.lon.should == request.long }
      it("has the same type code")              { subject.type_code.should == request.service.code }

    end

  end

end
