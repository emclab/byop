Byop::Application.routes.draw do
  
  get "sys_logs/index"

  get "out_logs/new"

  get "out_logs/create"

  get "out_logs/show"

  get "parts/index"

  get "parts/new"

  get "parts/create"

  get "parts/edit"

  get "parts/update"

  get "parts/show"

  get "quality_issues/index"

  get "quality_issues/new"

  get "quality_issues/create"

  get "quality_issues/edit"

  get "quality_issues/update"

  get "quality_issues/show"

  get "installation_purchase_logs/new"

  get "installation_purchase_logs/create"

  get "installation_purchases/index"

  get "installation_purchases/new"

  get "installation_purchases/create"

  get "installation_purchases/edit"

  get "installation_purchases/update"

  get "installation_purchases/show"

  get "proj_modules/new"

  get "proj_modules/create"

  get "installation_logs/index"

  get "installation_logs/new"

  get "installation_logs/create"

  get "sourcing_logs/index"

  get "sourcing_logs/new"

  get "sourcing_logs/create"

  get "purchasing_logs/index"

  get "purchasing_logs/new"

  get "purchasing_logs/create"

  get "production_logs/index"

  get "production_logs/new"

  get "production_logs/create"

  get "installations/index"

  get "installations/new"

  get "installations/create"

  get "installations/edit"

  get "installations/update"

  get "sourcings/index"

  get "sourcings/new"

  get "sourcings/create"

  get "sourcings/edit"

  get "sourcings/update"

  get "sourcings/show"

  get "purchasings/index"

  get "purchasings/new"

  get "purchasings/create"

  get "purchasings/edit"

  get "purchasings/update"

  get "purchasings/show"

  get "productions/index"

  get "productions/new"

  get "productions/create"

  get "productions/edit"

  get "productions/update"

  get "productions/show"

  get "manufacturers/index"

  get "manufacturers/new"

  get "manufacturers/create"

  get "manufacturers/edit"

  get "manufacturers/update"

  get "project_logs/new"

  get "project_logs/create"

  get "project_logs/show"

  get "project_logs/destroy"

  get "projects/index"

  get "projects/new"

  get "projects/create"

  get "projects/edit"

  get "projects/update"

  get "projects/show"

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

  resource :session
  resources :user_menus, :only => [:index]
  resources :manufacturers, :only => [:index, :new, :create, :edit, :update]
  resources :users do
    resources :user_levels
  end
  resources :customers do
    resources :comm_logs, :only => [:new, :create, :show, :destroy]
  end
  resources :src_plants
  resources :suppliers
  resources :quality_issues, :only  => [:index]
  resources :projects do
    member do
      put :cancel
      put :re_activate
    end
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results
    end
    resources :project_logs, :only => [:new, :create, :show, :destroy]
    resources :productions, :only => [:index, :new, :create, :edit, :update, :show]
    resources :sourcings, :only => [:index, :new, :create, :edit, :update, :show] do
      member do
        put :approve
        put :dis_approve
        put :re_approve
      end
    end
    resources :purchasings, :only => [:index, :new, :create, :edit, :update, :show] do
      member do
        put :approve
        put :dis_approve
        put :re_approve
      end
      collection do
        get :search
        put :search_results
        get :stats
        put :stats_results
      end 
    end
    resources :installations, :only => [:index, :new, :create, :edit, :update] 
    resources :proj_modules, :only => [:new, :create]
    resources :quality_issues, :only => [:new, :create, :edit, :update, :show] 
  end  #end projects
  #for search and stats only
  resources :purchasings, :only => [:index, :new, :create, :edit, :update, :show] do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results
    end 
  end  
  resources :productions do
    resources :production_logs, :only => [:index, :new, :create]
  end
  resources :purchasings do
    resources :purchasing_logs, :only => [:index, :new, :create] 
  end
  
  resources :sourcings do
    resources :sourcing_logs, :only => [:index, :new, :create]   
  end
  
  resources :installation_purchases, :only => [:index]  
  resources :installations do
    resources :installation_logs, :only => [:index, :new, :create]
    resources :installation_purchases, :only => [:new, :create, :edit, :update, :show] do
      member do
        put :approve
        put :dis_approve
        put :re_approve        
      end
    end          
  end  
  resources :installation_purchases do
    member do
      put :warehousing
    end
    resources :installation_purchase_logs, :only => [:new, :create]
  end  
  
  resources :parts do
    resources :out_logs, :only => [:new, :create, :show]
  end
  
  #resources :sys_logs, :only => [:index]
  resources :sys_logs, :only => [:index] do
    collection do
      get :sort_by_user_id
      get :sort_by_ip
    end
  end   
  
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
