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
end
