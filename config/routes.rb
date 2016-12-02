Rails.application.routes.draw do

    root 'rowdata#index'
    resources :rowdata
end
