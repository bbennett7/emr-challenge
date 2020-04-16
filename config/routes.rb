Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'application#root'

  post '/webhook-gateway', to: 'webhook#gateway'
end


#add in token to callback URL?
# start with webhook callback for plans route
# POST request --> gateway for different services --> case / switch to call handleFuncts --> handle functs parse through --> default case will do best job to find data -->

# in handle functs, do work to find existing data and update or insert new - account for typos
