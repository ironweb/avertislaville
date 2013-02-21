# encoding: UTF-8
require 'spec_helper'
require 'json'

class RestStub
  attr_accessor :get

  def [](key)
    return self
  end

end

describe ApiWrapper do

  it "returns an empty list when no services" do
    resource = RestStub.new
    resource.get = ""

    wrapper = ApiWrapper.new(resource)
    expect(wrapper.services).to eq([])
  end

  it "returns once service" do
    resource = RestStub.new()
    service_json = [{
      "description"=>"Description à venir",
      "group"=>"Ordures",
      "keywords"=> "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres",
      "metadata"=>true,
      "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
      "service_name"=>"Collecte des encombrants - secteur résidentiel",
      "type"=>"batch"
    }].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)
    services = wrapper.services

    expect(services.length).to eq(1)
    service = services[0]

    expect(service.name).to eq("Collecte des encombrants - secteur résidentiel")
    expect(service.code).to eq("1934303d-7f43-e111-85e1-005056a60032")
    expect(service.group).to eq("Ordures")
    expect(service.description).to eq("Description à venir")
    expect(service.metadata).to eq(true)
    expect(service.type).to eq("batch")
  end

  it "returns a service with minimal keys" do
    resource = RestStub.new()
    service_json = [{
      "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
      "service_name"=>"Collecte des encombrants - secteur résidentiel",
      "group"=>"Ordures",
      "description"=>"Description à venir",
      "metadata"=>true,
      "type"=>"batch"
    }].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)
    services = wrapper.services

    expect(services.length).to eq(1)
    service = services[0]

    expect(service.name).to eq("Collecte des encombrants - secteur résidentiel")
    expect(service.code).to eq("1934303d-7f43-e111-85e1-005056a60032")
    expect(service.group).to eq("Ordures")
    expect(service.description).to eq("Description à venir")
    expect(service.metadata).to eq(true)
    expect(service.type).to eq("batch")
  end

  it "returns the names of the groups" do
    resource = RestStub.new
    service_json = [{
      "description"=>"Description à venir",
      "group"=>"Ordures",
      "keywords"=> "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres",
      "metadata"=>true,
      "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
      "service_name"=>"Collecte des encombrants - secteur résidentiel",
      "type"=>"batch"
    }].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)

    expect(wrapper.group_names).to eq(["Ordures"])
  end

  it "returns a single group name with 2 services" do
    resource = RestStub.new
    service_json = [
      {
        "description"=>"Description à venir",
        "group"=>"Ordures",
        "keywords"=> "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres",
        "metadata"=>true,
        "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"Collecte des encombrants - secteur résidentiel",
        "type"=>"batch"
      },
      {
        "description"=>"blabla",
        "group"=>"Ordures",
        "keywords"=> "other,keywords",
        "metadata"=>false,
        "service_code"=>"1834303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"new service name",
        "type"=>"batch"
      }
    ].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)

    result = ["Ordures"]
    expect(wrapper.group_names).to eq(result)
  end

  it "returns a single group name with 2 services" do
    resource = RestStub.new
    service_json = [
      {
        "description"=>"Description à venir",
        "group"=>"Ordures",
        "keywords"=> "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres",
        "metadata"=>true,
        "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"Collecte des encombrants - secteur résidentiel",
        "type"=>"batch"
      },
      {
        "description"=>"blabla",
        "group"=>"Trottoirs",
        "keywords"=> "other,keywords",
        "metadata"=>false,
        "service_code"=>"1834303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"new service name",
        "type"=>"batch"
      }
    ].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)

    result = ["Ordures", "Trottoirs"]
    expect(wrapper.group_names).to eq(result)
  end

  it "groups services together" do
    resource = RestStub.new
    service_json = [
      {
        "description"=>"Description à venir",
        "group"=>"Ordures",
        "keywords"=> "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres",
        "metadata"=>true,
        "service_code"=>"1934303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"Collecte des encombrants - secteur résidentiel",
        "type"=>"batch"
      },
      {
        "description"=>"blabla",
        "group"=>"Trottoirs",
        "keywords"=> "other,keywords",
        "metadata"=>false,
        "service_code"=>"1834303d-7f43-e111-85e1-005056a60032",
        "service_name"=>"new service name",
        "type"=>"batch"
      }
    ].to_json

    resource.get = service_json

    wrapper = ApiWrapper.new(resource)

    result = wrapper.groups
    expect(result.keys).to eq(["Ordures", "Trottoirs"])
    expect(result["Ordures"]).to be_an_instance_of(Array)
    expect(result["Ordures"][0]).to be_an_instance_of(Service)
  end

end
