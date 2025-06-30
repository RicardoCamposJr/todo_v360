require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:todo_list) { user.todo_lists.create!(title: "My List") }
  let(:item) { todo_list.items.create!(title: "Item Test", status: :to_do) }

  before { login_as(user, scope: :user) }

  describe "PATCH /todo_lists/:todo_list_id/items/:id/update_status" do
    it "updates the status of the item" do
      patch update_status_todo_list_item_path(todo_list, item), params: { item: { status: "done" } }
      expect(response).to redirect_to(todo_list)
      expect(item.reload.status).to eq("done")
    end
  end
end
