SimpleHealthCheck::Engine.routes.draw do
  root to: 'simple_health_check#show', via: [:get]
  match '/detailed' => 'simple_health_check#show_detailed', :via => [:get]
end
