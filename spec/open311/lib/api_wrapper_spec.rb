# encoding: UTF-8
require 'spec_helper'
require 'open311_helper.rb'
require 'json'

class RestStub
  attr_accessor :get

  def initialize
    @responses = {}
  end

  def add_response(url, response)
    @responses[url] = response
  end

  def [](key)
    return Struct.new(:get).new(@responses[key])
  end

end


describe Open311::ApiWrapper do

  it "returns an empty list when no services" do
    resource = RestStub.new
    resource.add_response('/services.json', "")

    wrapper = Open311::ApiWrapper.new(resource)
    expect(wrapper.all_services).to eq([])
  end

  it "returns once service" do
    resource = RestStub.new()
    service_json = [sample_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)
    all_services = wrapper.all_services

    expect(all_services.length).to eq(1)
    service = all_services[0]

    expect(service.name).to eq("Collecte des encombrants - secteur résidentiel")
    expect(service.code).to eq("1934303d-7f43-e111-85e1-005056a60032")
    expect(service.group).to eq("Ordures")
    expect(service.description).to eq("Description à venir")
    expect(service.metadata).to eq(true)
    expect(service.type).to eq("batch")
    expect(service.to_param).to eq(service.code)
  end

  it "returns a service with minimal keys" do
    resource = RestStub.new()
    service_json = [min_sample_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)
    all_services = wrapper.all_services

    expect(all_services.length).to eq(1)
    service = all_services[0]

    expect(service.name).to eq("Collecte des encombrants - secteur résidentiel")
    expect(service.code).to eq("1934303d-7f43-e111-85e1-005056a60032")
    expect(service.group).to eq("Ordures")
    expect(service.description).to eq("Description à venir")
    expect(service.metadata).to eq(true)
    expect(service.type).to eq("batch")
  end

  it "returns the names of the groups" do
    resource = RestStub.new
    service_json = [min_sample_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)

    expect(wrapper.group_names).to eq(["Ordures"])
  end

  it "returns a single group name with 2 services" do
    resource = RestStub.new
    service_json = [sample_service, sample_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)

    result = ["Ordures"]
    expect(wrapper.group_names).to eq(result)
  end

  it "returns a single group name with 2 services" do
    resource = RestStub.new
    second_service = sample_service.dup
    second_service['group'] = 'Trottoirs'
    service_json = [sample_service, second_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)

    result = ["Ordures", "Trottoirs"]
    expect(wrapper.group_names).to eq(result)
  end

  it "groups services together" do
    resource = RestStub.new
    second_service = sample_service.dup
    second_service['group'] = 'Trottoirs'
    service_json = [sample_service, second_service].to_json
    resource.add_response('/services.json', service_json)

    wrapper = Open311::ApiWrapper.new(resource)

    result = wrapper.groups
    expect(result.keys).to eq(["Ordures", "Trottoirs"])
    expect(result["Ordures"]).to be_an_instance_of(Array)
    expect(result["Ordures"][0]).to be_an_instance_of(Open311::Service)
  end

  it "returns no attrs with an empty string" do
    resource = RestStub.new
    attribute_json = ""
    resource.add_response('/services/01234-1234-1234-1234.json', attribute_json)

    code = "01234-1234-1234-1234"
    wrapper = Open311::ApiWrapper.new(resource)
    result = wrapper.attrs_from_code(code)

    expect(result).to eq([])
  end

  it "returns one attribute" do
    resource = RestStub.new
    attribute_json = sample_attribute.to_json
    resource.add_response('/services/01234-1234-1234-1234.json', attribute_json)

    code = "01234-1234-1234-1234"
    wrapper = Open311::ApiWrapper.new(resource)
    result = wrapper.attrs_from_code(code)

    expect(result.length).to eq(1)
    attribute = result[0]

    expect(attribute.code).to eq("7041ac51-ec75-e211-9483-005056a613ac")
    expect(attribute.datatype).to eq("text")
    expect(attribute.description).to eq("Pour disposer d`appareils contenant des halocarbures (congélateur, réfrigérateur, climatiseur, etc.), veuillez communiquer avec votre bureau d'arrondissement.")
    expect(attribute.datatype_description).to eq("Pour disposer d`appareils contenant des halocarbures (congélateur, réfrigérateur, climatiseur, etc.), veuillez communiquer avec votre bureau d'arrondissement.")
    expect(attribute.order).to eq(2)
    expect(attribute.required).to eq(false)
    expect(attribute.values).to eq([])
    expect(attribute.variable).to eq(false)
  end

  it "returns a service with an attribute" do
    resource = RestStub.new
    service_json = [sample_service].to_json
    attribute_json = sample_attribute.to_json
    resource.add_response('/services.json', [sample_service].to_json)
    resource.add_response('/services/1934303d-7f43-e111-85e1-005056a60032.json', attribute_json)

    wrapper = Open311::ApiWrapper.new(resource)
    services = wrapper.services_with_attrs
    service = services[0]

    expect(service.name).to eq("Collecte des encombrants - secteur résidentiel")
    expect(service.code).to eq("1934303d-7f43-e111-85e1-005056a60032")
    expect(service.group).to eq("Ordures")
    expect(service.description).to eq("Description à venir")
    expect(service.metadata).to eq(true)
    expect(service.type).to eq("batch")

    attribute = service.attrs[0]

    expect(attribute.code).to eq("7041ac51-ec75-e211-9483-005056a613ac")
    expect(attribute.datatype).to eq("text")
    expect(attribute.description).to eq("Pour disposer d`appareils contenant des halocarbures (congélateur, réfrigérateur, climatiseur, etc.), veuillez communiquer avec votre bureau d'arrondissement.")
    expect(attribute.datatype_description).to eq("Pour disposer d`appareils contenant des halocarbures (congélateur, réfrigérateur, climatiseur, etc.), veuillez communiquer avec votre bureau d'arrondissement.")
    expect(attribute.order).to eq(2)
    expect(attribute.required).to eq(false)
    expect(attribute.values).to eq([])
    expect(attribute.variable).to eq(false)
  end

end
