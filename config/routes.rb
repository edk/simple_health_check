SimpleHealthCheck::Engine.routes.draw do
  root to: 'simple_health_check#show', via: [:get]
end
