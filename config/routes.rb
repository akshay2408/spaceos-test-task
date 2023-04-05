Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :short_links, only: [:create, :show]
end
