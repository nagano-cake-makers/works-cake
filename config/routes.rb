Rails.application.routes.draw do

  get 'customers/show'
  get 'deliveries/index'
    namespace :admin do
      get 'search/search'
    end

    # admin
    devise_for :admin, path: 'admin', controllers: {
      sessions: 'admin/sessions',
      registrations: 'admin/registrations',
    }

    namespace :admin do
      get '/search' => 'search#search'
      resources :customers, only: [:index, :show, :edit, :update]
      resources :items, only: [:index, :new, :create, :show, :edit, :update]
      resources :genres, only: [:index, :create, :edit, :update, :show]
      resources :orders, only: [:index, :show, :update] do
        collection do
          get :today_order_index
        end
        member do
          get :current_index
        end
        resources :order_details, only: [:update]
      end
    end

    # customer
    devise_for :customer, path: 'customer', controllers: {
      sessions: 'customer/sessions',
      registrations: 'customer/registrations',
      passwords: 'customer/passwords'
    }

    get 'about' => 'customer/homes#about', as: 'customer_about'
    root 'customer/homes#top'
    get 'my_page' => 'customer/customers#show', as: 'customer_my_page'
    get '/items' => 'customer/items#index'
    get '/items/:id' => 'customer/items#show', as: :customer_item
    get '/customers/contact' => 'customer/customers#contact'

    scope module: :customer do
      resources :items, only: [:index, :show] do
        collection do
          get 'search'
        end
      end
      get 'edit/publics' => 'publics#edit', as: :edit_customer_public
      patch 'update/publics' => 'publics#update', as: :update_customer_public
      resource :publics, only: [:edit, :update, :show] do
        collection do
          get 'unsubscribe'
          patch 'withdraw'
        end
      end
      resources :cart_items, only: [:index, :update, :create, :destroy] do
        collection do
          delete :all_destroy
        end
      end
      resources :orders, only: [:new, :index, :show, :create] do
        collection do
          post 'confirm'
          get 'thanks'
        end
      end

      resources :deliveries, only: [:index, :create, :edit, :update, :destroy]
    end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end