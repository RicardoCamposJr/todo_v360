Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "welcome_page#index"

  # Protege as rotas da aplicação com autenticação de usuário
  authenticate :user do
    resources :todo_lists do
      resources :items, only: [ :new, :create, :edit, :update, :destroy ] do
        # Adiciona uma rota PATCH para a atualização do status de um item específico, para o drag and drop do Kanban
        member do
          patch :update_status
        end
      end
    end
  end

  # Letter Opener Web para visualizar e-mails em desenvolvimento
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
