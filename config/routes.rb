Rails.application.routes.draw do
  get 'users/login'
  post 'users/login'
  get 'users/logout'
  get 'users/register'
  post 'users/register'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  #root 'dashboards#index'

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'admin'
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/admin/processes"
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :reports do
    collection do
      get 'list'
    end

    member do
      get 'execute'
      get 'columns'
      post 'display'
      get 'last_value'
      get 'observations'
      get 'observations_collection'
    end
  end
  
  resources :dashboards do
    collection do
      get 'widget_settings'
      post 'save_as'
    end
    member do
      get 'widgets'
    end
  end
  get 'dashboards/widget_data/:id' => 'dashboards#widget_data'
  
  resources :containers do
    collection do
      post 'execute'
    end
  end
  
  resources :alerts do
    collection do
      get 'list'
    end
  end

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  namespace :admin do
    resources :reports do
      collection do
        get 'list'
        get 'execute'
        post 'preview'
        post 'replace_macros'
      end
      member do
        get 'details'
        get 'observations'
        get 'observations_collection'
      end
    end
    
    resources :sources do
      member do
        get 'ping'
        get 'tables'
        get 'check'
      end
      collection do
        get 'list'
      end
    end
    
    resources :schedulers do
      collection do
        get 'list'
      end
    end
    
    resources :users do
      collection do
        get 'list'
      end
      member do
        get 'activate'
        get 'deactivate'
      end
    end
  end
end
