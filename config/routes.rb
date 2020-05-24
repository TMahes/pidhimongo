Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  #devise_for :users
  devise_for :users, :controllers => {:registrations => "registrations" , sessions: "sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root to: 'home#index'

  resources :conversations, only: [:create] do
    member do
      post :close
    end
    resources :messages, only: [:create]
  end

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  # devise_scope :user do
  #   get 'profile', to: 'devise/registrations#profile'
  # end
  post 'close', to: 'conversations#close'
  get 'profile', to: 'profile#profile'
  post 'profile', to: 'profile#create'

  get 'confirm', to: 'profile#confirm'
  post 'confirm', to: 'profile#update_details'
  
  get 'build_tree', to: 'build_tree#buildTree'

  post 'build_profile', to: 'profile#addtoProfiles'
  post 'build_family', to: 'family#addtoFamily'
  post 'build_genogram', to: 'genogram#addtoGenogram'
  get 'family_tree', to: 'family#showTree'
  get 'genogram_tree', to: 'genogram#showTree'
  post 'genogram_upload', to: 'genogram#updateImage'
  post 'genogram_delete', to: 'genogram#deleteDocument'
  post 'genogram_edit', to: 'genogram#edit_field'
  get 'show_tree', to: 'build_tree#showTree'
  get 'getTreeData', to: 'profile#getTreeData'
  get 'getFamilyData', to: 'family#getFamilyData'
  get 'getGenogramData', to: 'genogram#getGenogramData'
  get 'readonlygenogramData', to: 'genogram#readonlygenogramData'
  get 'readonly_genogram', to: 'genogram#readonlygenogram'
  post 'getFamilyJsonData', to: 'family#getFamilyJsonData'
  get 'view_profile', to: 'build_tree#viewProfile'
  get 'search_path', to: 'profile#searchProfile' , :defaults => { :format => 'text/html' }
   get 'search', to: 'profile#search'


end
