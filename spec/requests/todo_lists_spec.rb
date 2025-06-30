require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:todo_list) { user.todo_lists.create!(title: "My List") }
  let(:item) { todo_list.items.create!(title: "Item Test", status: :to_do) }

  before { sign_in user }

  describe "PATCH /todo_lists/:todo_list_id/items/:id/update_status" do
    it "updates the status of the item" do
      patch update_status_todo_list_item_path(todo_list, item), params: { status: "done" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json = JSON.parse(response.body)
      expect(json["success"]).to be true
      expect(json["item_id"]).to eq(item.id)
      expect(json["new_status"]).to eq("done")

      expect(item.reload.status).to eq("done")
    end
  end
end
