Rails.application.routes.draw do

    root 'rowdata#index'
    resources :rowdata

   namespace :api, {format: 'json'} do
       resources :rowdata
   end
end