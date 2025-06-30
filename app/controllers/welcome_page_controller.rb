class WelcomePageController < ApplicationController
  def index
    # Redirecionar usuários já logados para o dashboard
    if user_signed_in?
      redirect_to todo_lists_path
    end
  end
end
