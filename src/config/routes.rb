Auditorium::Application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do 

    devise_for :users, :controllers => { :passwords => "passwords",
                                         :confirmations => "confirmations", 
                                         :sessions => "sessions", 
                                         :registrations => "registrations" }

    post 'surveys/hide', to: 'users#hide_survey_banner', as: :hide_survey_banner

    get 'users/moderation', to: 'users#moderation', as: :users_moderation
    get 'users/moderation/search', to: 'users#search', as: :search_users
    post 'users/:id/confirm', to: 'users#confirm', :as => :confirm_user
    get 'users', to: 'users#index', as: :leaderboard
    resources :levels
    resources :badges
    resources :users do 
      member do
        post 'accept_privacy_policy'
      end
      resources :settings do 
        post 'groups'
      end
    end 

    resources :courses, only: [:show]

    resources :tags, only: [:index]
    post "ajax/preview", to: 'ajax#preview'
    post "ajax/load_form", to: 'ajax#load_form'
    get 'ajax/search', to: 'ajax#search', as: :search
    post ':type/:id/upvote', to: 'ajax#upvote', as: :upvote
    post ':type/:id/downvote', to: 'ajax#downvote', as: :downvote
    post 'ajax/tab_content', to: 'ajax#tab_content', as: :tab_content
    post 'ajax/markdown_sheet', to: 'ajax#load_markdown_sheet'
    post 'ajax/save_tutorial_progress', to: 'ajax#save_tutorial_progress'

    get 'groups/tagged/:tag', to: 'groups#tagged', as: :tag
    get 'search', to: 'search#index', as: :alternative_search
    get 'groups/change_group_type', to: 'groups#change_group_type'
    post 'groups/search_members', to: 'groups#search_members', as: :search_members
    post 'groups/manage_membership', to: 'groups#manage_membership', as: :manage_membership
    get 'groups/my_groups', to: 'groups#my_groups', as: :my_groups

    post 'groups/:group_id/membership_requests/make', to: 'membership_requests#make', as: :make_membership_request 
    post 'groups/:group_id/membership_requests/cancel', to: 'membership_requests#cancel', as: :cancel_membership_request
    post 'groups/:group_id/membership_requests/:id/confirm', to: 'membership_requests#confirm', as: :confirm_membership_request
    post 'groups/:group_id/membership_requests/:id/reject', to: 'membership_requests#reject', as: :reject_membership_request

    shallow do 
      resources :groups do
        member do
          post 'following'
          post 'show_members_list'
          post 'approve'
          post 'decline'
          post 'reactivate'
        end

        resources :membership_requests, only: [:index, :destroy] 

        resources :videos do 
          resources :comments
        end

        resources :announcements do
          resources :comments
        end
        
        resources :topics do
          resources :comments, except: [:show, :index, :new]
        end
        
        resources :questions do
          resources :comments
          resources :answers, except: [:index, :new] do
            member do 
              post 'helpful', to: 'answers#toggle_as_helpful'
            end
            resources :comments, except: [:index, :new]
          end
        end
      end
    end

    resources :notifications, only: [:index, :show, :destroy]
    post 'notifications/mark_all_as_read', to: 'notifications#mark_all_as_read', as: :mark_all_notifications_as_read
    post 'notifications/delete_all', to: 'notifications#delete_all', as: :delete_all_notifications
    post 'notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: :mark_notification_as_read
    mathjax 'mathjax'
    
    get 'intro', :to => 'landing_page#index'
    get 'home', :to => 'home#index'
    get 'permission_denied', :to => 'applications#permission_denied', :as => :permission_denied


    resources :events
    get "imprint", to: 'static_pages#imprint', as: :imprint
    get "privacy", to: 'static_pages#privacy', as: :privacy
    get "story", to: 'static_pages#story', as: :story
    root to: "landing_page#index"
    match '*unmatched_route', :to => 'application#render_not_found'
  end
  
  # match '*path', to: redirect {|params| "/#{I18n.default_locale}/#{CGI::unescape(params[:path])}" }, constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  # match '', to: redirect("/#{I18n.default_locale}")   
  match '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  match '', to: redirect("/#{I18n.default_locale}")
end
