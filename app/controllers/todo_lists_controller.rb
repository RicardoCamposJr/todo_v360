class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list, only: [ :show, :edit, :update, :destroy ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @todo_lists = current_user.todo_lists
  end

  def show
    @items = @todo_list.items.order(created_at: :desc)
  end

  def new
    @todo_list = current_user.todo_lists.new
  end

  def create
    @todo_list = current_user.todo_lists.new(todo_list_params)
    if @todo_list.save
      redirect_to @todo_list, notice: "Lista criada com sucesso."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @todo_list.update(todo_list_params)
      redirect_to @todo_list, notice: "Lista atualizada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    if @todo_list.destroy
      redirect_to todo_lists_path, notice: "Lista removida."
    else
      redirect_to @todo_list, alert: "Erro ao remover a lista."
    end
  end

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:id])
  end

  def todo_list_params
    params.require(:todo_list).permit(:title)
  end

  def record_not_found
    redirect_to todo_lists_path, alert: "Lista não encontrada."
  end
end
