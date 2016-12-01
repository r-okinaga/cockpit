Rails.application.routes.draw do
    root 'rowdata#index'

    namespace :api, {format: 'json'} do
        controller 'rowdata' do
          post 'create'
        end
    end
end
