Rails.application.routes.draw do

    namespace :api, {format: 'json'} do
        resources :rowdatum
    end

    root 'rowdata#index'
    resources :rowdatum
end
