Byop::Application.routes.draw do
  
  get "suppliers/index"

  get "suppliers/new"

  get "suppliers/create"

  get "suppliers/edit"

  get "suppliers/update"

  get "suppliers/show"

  get "src_plants/index"

  get "src_plants/new"

  get "src_plants/create"

  get "src_plants/edit"

  get "src_plants/update"

  get "src_plants/show"

  get "comm_logs/new"

  get "comm_logs/create"

  get "comm_logs/show"

  get "comm_logs/destroy"

  get "customers/index"

  get "customers/new"

  get "customers/create"

  get "customers/edit"

  get "customers/update"

  get "customers/show"

  get "user_menus/index"

  get "users/index"

  get "users/show"

  get "users/new"

  get "users/create"

  get "users/edit"

  get "users/update"

  #get "sessions/create"

  #get "sessions/destroy"
  
  resource :session
  resources :user_menus, :only => [:index]
  resources :users do
    resources :user_levels
  end
  resources :customers do
    resources :comm_logs, :only => [:new, :create, :show]
  end
  resources :src_plants
  resources :suppliers
  
  root :to => "sessions#new"
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'application#view_handler'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
