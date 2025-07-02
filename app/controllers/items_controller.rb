class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list
  before_action :set_item, only: [ :update, :destroy, :edit, :update_status ]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    if @item.destroy
      redirect_to @todo_list, notice: "Tarefa removida."
    else
      redirect_to @todo_list, alert: "Erro ao remover tarefa."
    end
  end

  # Endpoint para atualizar o status de uma task pelo kanban
  def update_status
    if @item.update(status: params[:status])
      render json: {
        success: true,
        item_id: @item.id,
        new_status: @item.status,
        message: "Status atualizado com sucesso"
      }
    else
      render json: {
        success: false,
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
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

  def record_not_found
    redirect_to todo_lists_path, alert: "Tarefa ou lista não encontrada."
  end
end
