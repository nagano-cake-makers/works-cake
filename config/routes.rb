Rails.application.routes.draw do
  namespace :customer do
    get 'homes/top'
    get 'homes/about', to: 'homes#about', as: 'about'
  end
  namespace :admin do
    get 'homes/top'
  end

  root 'homes#top'
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions',
  }
  devise_for :customer, skip: [:passwords], controllers: {
    registrations: "customer/registrations",
    sessions: 'customer/sessions',
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
