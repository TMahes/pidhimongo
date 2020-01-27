Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, :controllers => {:registrations => "registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'home#index'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  # devise_scope :user do
  #   get 'profile', to: 'devise/registrations#profile'
  # end

  get 'profile', to: 'profile#profile'
  post 'profile', to: 'profile#create'

  get 'confirm', to: 'profile#confirm'
  post 'confirm', to: 'profile#update_details'

  get 'build_tree', to: 'build_tree#buildTree'

  post 'build_profile', to: 'profile#addtoProfiles'
  get 'show_tree', to: 'build_tree#showTree'
  get 'getTreeData', to: 'profile#getTreeData'
  get 'view_profile', to: 'build_tree#viewProfile'
  get 'search_path', to: 'profile#searchProfile' , :defaults => { :format => 'text/html' }
   get 'search', to: 'profile#search'


end
