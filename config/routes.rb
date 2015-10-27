Rails.application.routes.draw do
  resources :scores
  resources :rounds
  resources :tour_parts
  resources :tees
  resources :holes
  resources :courses
  resources :competitions
  resources :clubs
  resources :users

  get 'sessions/new'

  get '/'         => 'pages#index'
  get '/users'    => 'users#index'
  get '/signup'   => 'users#new'
  get '/login'    => 'sessions#new'
  post '/login'   => 'sessions#create'
  delete '/logout'=> 'sessions#destroy'

  get '/admin'              => 'admins#index'
  get '/admin/users'        => 'admins#users'
  get '/admin/clubs'        => 'admins#clubs'
  get '/admin/competitions' => 'admins#competitions'
  get '/admin/courses'      => 'admins#courses'
  get '/admin/tees'         => 'admins#tees'
  get '/admin/user/new'     => 'admins#create_player'
  get '/admin/round'        => 'admins#rounds'
  get '/admin/tours'        => 'admins#tours'
  post '/scores/update'     => 'scores#update'

  get '/competition/statistics' => 'competitions#statistics'
  get '/competition/records' => 'competitions#records'
  get '/statistics/headtohead/' => 'statistics#headtohead'

  get 'stats'   => 'statistics#index'

end
