Rails.application.routes.draw do
  scope "(:locale)", locale: /en|sv/ do
    resources :imports
    resources :scores, :rounds, :tour_parts, :tees, :holes, :courses, :competitions, :clubs, :users, :statistics

    get 'sessions/new'

    root :to => "pages#index"
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
    get '/admin/imports'      => 'admins#imports'
    post '/scores/update'     => 'scores#update'

    get '/course/statistics'      => 'courses#statistics'

    get '/competition/statistics' => 'competitions#statistics'
    get '/competition/records'    => 'competitions#records'
    get '/competition/tours'      => 'competitions#tours'
    get '/statistics/headtohead/' => 'statistics#headtohead'
    get '/competition/totals'     => 'competitions#totals'
    get '/tour_part_line_chart'   => 'tour_parts#line_chart'
    get '/import_tour_part'       => 'imports#import_tour_part'

    get 'stats'   => 'statistics#index'
    get 'hole_stats' => 'statistics#hole_stats'

    get 'import' => 'tour_parts#import_tour_part'
  end
end
