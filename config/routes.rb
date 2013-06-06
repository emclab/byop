Byop::Application.routes.draw do

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
  resources :shipment, :only => [:index]
  #start: project
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
    resources :shipments, :only => [:new, :create, :edit, :update, :show] do
      member do
        put :approve
        put :dis_approve
      end
    end
    
    resources :sourcings, :only => [:index, :new, :create, :edit, :update, :show] do
      member do
        put :approve
        put :dis_approve
        put :re_approve
        put :stamp
      end

    end
    resources :purchasings, :only => [:index, :new, :create, :edit, :update, :show, :destroy] do
      member do
        put :approve
        put :dis_approve
        put :re_approve
        put :stamp
      end

    end
    resources :installations, :only => [:index, :new, :create, :edit, :update] 
    resources :proj_modules, :only => [:new, :create]
    resources :quality_issues, :only => [:new, :create, :edit, :update, :show] 
  end  
  #end projects

  resources :productions do
    resources :production_logs, :only => [:index, :new, :create]
  end
  
  resources :payment_logs, :only =>[:index]
  resources :purchasings do
    collection do
      get :search
      put :search_results
    end     
    resources :purchasing_logs, :only => [:index, :new, :create] 
    resources :payment_logs, :only => [:index, :new, :create, :edit, :update, :show]
  end
  
  resources :sourcings do
    collection do
      get :search
      put :search_results
    end      
    resources :sourcing_logs, :only => [:index, :new, :create]   
    resources :payment_logs, :only => [:index, :new, :create, :edit, :update, :show]
  end
  resources :payment_logs do
    resources :pay_status_logs, :only => [:new, :create]
    member do
      put :approve
      put :stamp_paid
    end
    collection do
      get :search
      put :search_results      
      get :stats
      put :stats_results
    end  
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
  
  resources :shipments do
    resources :shipment_items, :only => [:index]
  end
  
  resources :shipment_items do
    resources :box_items
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
