Rails.application.routes.draw do

    root 'rowdata#index'
    get 'rowsata/s_save', to: 'rowdata#s_save'
    resources :rowdata

   namespace :api, {format: 'json'} do
       resources :rowdata
   end
end