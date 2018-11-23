Rails.application.routes.draw do
  
	root 'static_pages#home'
  get 'static_pages/home'

  get 'static_pages/help'
  #manually adding an about page 
  #hence tell rails to route a get request for /about url
  get  'static_pages/about'

  get  'static_pages/contact'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
