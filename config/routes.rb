Rouges::Application.routes.draw do
  root :to => 'home#home'
  get  'request/:service' => 'requests#new', :as => :request
  post 'request/:service' => 'requests#create', :as => :request
  resources 'services', only: [:index]
end
