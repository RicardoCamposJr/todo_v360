require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:todo_list) { user.todo_lists.create!(title: "Minha Lista") }
  let(:item) { todo_list.items.create!(title: "Tarefa inicial", status: :to_do) }

  before do
    post user_session_path, params: { user: { email: user.email, password: 'password' } }
  end

  describe "GET /todo_lists/:todo_list_id/items/new" do
    it "returns http success" do
      get new_todo_list_item_path(todo_list)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /todo_lists/:todo_list_id/items/:id/edit" do
    it "returns success" do
      get edit_todo_list_item_path(todo_list, item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /todo_lists/:todo_list_id/items/:id" do
    context "with valid params" do
      it "update item and redirect to todo_list" do
        patch todo_list_item_path(todo_list, item), params: { item: { title: "Tarefa atualizada" } }
        expect(response).to redirect_to(todo_list)
        expect(item.reload.title).to eq("Tarefa atualizada")
      end
    end

    context "with valid params" do
      it "render edit with 422 status" do
        patch todo_list_item_path(todo_list, item), params: { item: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Edit") # ou algo que confirme que renderizou o form
      end
    end
  end

  describe "DELETE /todo_lists/:todo_list_id/items/:id" do
    it "remove item and redirect to todo_list" do
      item # cria o item antes do expect
      expect {
        delete todo_list_item_path(todo_list, item)
      }.to change(Item, :count).by(-1)
      expect(response).to redirect_to(todo_list)
    end
  end

  describe "PATCH /todo_lists/:todo_list_id/items/:id/update_status" do
    it "update item status and returns success JSON" do
      patch update_status_todo_list_item_path(todo_list, item), params: { status: "done" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json = JSON.parse(response.body)
      expect(json["success"]).to eq(true)
      expect(json["item_id"]).to eq(item.id)
      expect(json["new_status"]).to eq("done")

      expect(item.reload.status).to eq("done")
    end

    it "returns error if invalid status" do
      patch update_status_todo_list_item_path(todo_list, item), params: { status: "" }
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["success"]).to eq(false)
      expect(json["errors"]).to include("Status can't be blank")
    end
  end
end
