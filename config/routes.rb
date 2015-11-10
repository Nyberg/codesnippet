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
  get '/competition/totals' => 'competitions#totals'
  get '/tour_part_line_chart' => 'tour_parts#line_chart'

  get 'stats'   => 'statistics#index'
  get 'hole_stats' => 'statistics#hole_stats' 

end
