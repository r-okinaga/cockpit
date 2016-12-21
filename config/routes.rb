Rails.application.routes.draw do

    root 'rowdata#index'
    get 'rowdata/s_save', to: 'rowdata#s_save'
    post 'rowdata/create', to: 'rowdata#create'

   namespace :api, {format: 'json'} do
       resources :rowdata
   end
end