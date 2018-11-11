Rails.application.routes.draw do
  get 'account/edit'
  patch '/account/update' , to: "account#update"
  devise_for :users
  
  root to: "home#index"
  get '/tags', to: 'home#tags'
  
  get '/trips' , to: "trips#index"
  get '/trips/new' , to: "trips#new"
  post '/trips/create' , to: "trips#create"
  get '/trips/:id/edit' , to: "trips#edit"
  patch '/trips/:id/update' , to: "trips#update"
  post '/trips/:id/destroy' , to: "trips#destroy"

end
