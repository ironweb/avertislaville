Rouges::Application.routes.draw do
  get  'request/:service' => 'requests#new', :as => :request
end
