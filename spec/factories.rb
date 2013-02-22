# encoding: utf-8
FactoryGirl.define do
  factory :open311_service, :class => 'Open311::Service' do
    service_code "1934303d-7f43-e111-85e1-005056a60032"
    service_name "Collecte des encombrants - secteur résidentiel"
    group "Ordures"
    description "Description à venir"
    metadata true
    type "batch"

    trait :with_optionnal do
      keywords "Collecte,Encombrants,Gros déchets,Grosses poubelles,Grosses vidanges,Meubles,Monstres"
    end
  end

  factory :open311_attribute, :class => 'Open311::Attribute' do
    code "7041ac51-ec75-e211-9483-005056a613ac"
    datatype "text"
    datatype_description  "Pour disposer d`appareils contenant des halocarbures (congélateur réfrigérateur climatiseur etc.) veuillez communiquer avec votre bureau d'arrondissement."
    description  "Pour disposer d`appareils contenant des halocarbures (congélateur réfrigérateur climatiseur etc.) veuillez communiquer avec votre bureau d'arrondissement."
    order 2
    required false
    values []
    variable false
  end

  factory :open311_request, :class => 'Request' do
    ignore do
      service :nil
    end

    lat 12.34
    long 56.78

    initialize_with { new(FactoryGirl.build(:open311_service)) }
  end

  factory :open311_request_full, :class => 'Request' do
    ignore do
      service :nil
    end

    description "desc"
    lat 12.34
    long 56.78
    email "email@test.com"
    device_id 1
    account_id 2
    first_name "firstname"
    last_name "lastname"
    phone "55512345678"
    description "description"
    media_url "http://url"

    initialize_with { new(FactoryGirl.build(:open311_service)) }
  end
end
