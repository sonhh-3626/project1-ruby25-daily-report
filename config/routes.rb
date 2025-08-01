Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
<<<<<<< HEAD
    resources :users, only: %i(index edit update)
=======
>>>>>>> ef531e2 ([Admin] Quản lý bộ phận (CRUD))
    resources :departments
    namespace :admin do
      resources :departments
    end
  end
end
