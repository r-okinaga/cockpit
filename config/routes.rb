Rails.application.routes.draw do

    root 'rowdata#index'
    post 'rowdata/show', to: 'rowdata#show'
    post 'rowdata/create', to: 'rowdata#create'

   namespace :api, {format: 'json'} do
       get 'rowdata/index', to: 'rowdata#index'
   end
end