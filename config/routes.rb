Rails.application.routes.draw do

  devise_for :users
  devise_for :managers
  
  root 'products#index'

  namespace :manager do
    get 'index' => 'core#index'
    get 'zbc' => "core#zbc"
    resources :products do
      member do
        post :off_shelf
        post :on_shelf
      end
    end    
    resources :orders do
      member do
        post :cancel
        post :shipped
        post :return
      end
    end 
  end 

  resources :products do
    member do 
      post :add_to_cart
    end
  end  

  resources :carts  do 
    collection do 
      post :checkout
      post :refresh
      delete :delete_cart_item
      delete :clean
    end
  end

  resources :orders  do 
    member do 
      post :return
      post :pay2go_cc_notify
      post :pay2go_atm_complete
    end
  end   

  namespace :account do 
    resources :orders do 
      member do 
        post :cancel
      end
    end    
  end    
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
end
