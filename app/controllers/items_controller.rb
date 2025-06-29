class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list
  before_action :set_item, only: [ :update, :destroy, :edit ]

  def new
    @item = @todo_list.items.new
  end

  def create
    @item = @todo_list.items.new(item_params)
    if @item.save
      redirect_to @todo_list, notice: "Tarefa criada."
    else
      redirect_to @todo_list, alert: "Erro ao criar tarefa."
    end
  end

  def edit
    # @item e @todo_list já são setados pelos before_actions
  end

  def update
    if @item.update(item_params)
      redirect_to todo_list_path(@todo_list), notice: "Tarefa atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to @todo_list, notice: "Tarefa removida."
  end

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
  end

  def set_item
    @item = @todo_list.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :status, :description)
  end
end
