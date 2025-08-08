Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#help"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :departments
    namespace :admin do
      get "dashboard/show", to: "dashboard#show"
      resources :departments
      resources :users, only: %i(index edit update)
    end
    namespace :manager do
      get "dashboard/show", to: "dashboard#show"
      resources :departments, only: %i(index show)
      resources :users, only: %i(new create index show destroy)
      resources :daily_reports, only: %i(edit index update)
    end
    namespace :user do
      get "dashboard/show", to: "dashboard#show"
      resources :daily_reports
    end
  end
end
