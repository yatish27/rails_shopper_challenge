Rails.application.routes.draw do
  root 'home#index'

  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy', as: :logout

  resources :applicants do
    collection do
      get :apply
      post :next_step
      get :edit
      put :update
    end
  end
  resources :funnels, only: [:index]
end
