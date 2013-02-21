describe Request do
  subject do
    service = FactoryGirl.build(:open311_service, attrs: [
      FactoryGirl.build(:open311_attribute, :code => "some_attribute")])
    Request.new(service)
  end
  it { should respond_to(:some_attribute) }
  it { should respond_to(:some_attribute=) }
  it { should_not respond_to(:invalid_attribute) }
  it { should_not respond_to(:invalid_attribute=) }
  it "writes Open311 attribute values to ActiveAttr's" do
    subject.some_attribute = 'Value 123'
    subject.some_attribute.should == 'Value 123'
  end

  it "merges ActiveAttr and Open311 fields when calling #attributes" do
    subject.attributes.should have_key(:some_attribute)
  end

end
