Rouges::Application.routes.draw do
  root :to => 'home#home'
  get  'request/:service' => 'requests#new', :as => :request
  resources 'services', only: [:index]
end
