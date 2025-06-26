class TodoListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo_list

  def index
    @todo_lists = current_user.todo_lists
  end

  private

  def set_todo_list
    @todo_list = current_user.todo_lists.find(params[:id])
  end
end
