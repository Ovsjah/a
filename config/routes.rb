Rails.application.routes.draw do
  post '/create', to: 'items#create'
end
