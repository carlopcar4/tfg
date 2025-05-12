Rails.application.routes.draw do
  resources :councils, only: [:index, :show, :create, :update, :destroy] do
    member do
      patch "deploy"
    end

    member do
      patch "reset"
    end
  end
end
