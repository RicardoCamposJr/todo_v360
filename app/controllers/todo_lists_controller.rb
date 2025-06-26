class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list, only: [ :show ]

  def index
    @todo_lists = current_user.todo_lists
  end

  def show
    @items = @todo_list.items.order(:status)
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

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:id])
  end
end
