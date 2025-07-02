require 'rails_helper'

RSpec.describe "TodoLists", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let!(:todo_list) { user.todo_lists.create!(title: "Minha Lista") }

  before { sign_in user }

  describe "GET /todo_lists" do
    it "returns success" do
      get todo_lists_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Minha Lista")
    end

    it "returns only the lists belonging to the authenticated user" do
      other_user = User.create!(email: "outro@example.com", password: "password")
      other_user.todo_lists.create!(title: "Lista de Outro Usuário")

      get todo_lists_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Minha Lista")
      expect(response.body).not_to include("Lista de Outro Usuário")
    end
  end

  describe "GET /todo_lists/:id" do
    it "shows the list" do
      get todo_list_path(todo_list)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(todo_list.title)
    end

    it "redirects to the home if the list does not exist" do
      get todo_list_path(id: "99999")
      expect(response).to redirect_to(todo_lists_path)
      follow_redirect!
      expect(response.body).to include("Minhas listas")
    end
  end

  describe "GET /todo_lists/new" do
    it "renders the new list form" do
      get new_todo_list_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /todo_lists" do
    context "with valid parameters" do
      it "creates a new list and redirects" do
        expect {
          post todo_lists_path, params: { todo_list: { title: "Nova Lista" } }
        }.to change(TodoList, :count).by(1)
        expect(response).to redirect_to(TodoList.last)
        follow_redirect!
        expect(response.body).to include("Tarefas")
      end
    end

    context "with invalid parameters" do
      it "renders :new with errors" do
        post todo_lists_path, params: { todo_list: { title: "" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Criar lista")
      end
    end
  end

  describe "GET /todo_lists/:id/edit" do
    it "renders the edit form" do
      get edit_todo_list_path(todo_list)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /todo_lists/:id" do
    context "with valid parameters" do
      it "updates the list and redirects" do
        patch todo_list_path(todo_list), params: { todo_list: { title: "Lista Atualizada" } }
        expect(response).to redirect_to(todo_list)
        expect(todo_list.reload.title).to eq("Lista Atualizada")
      end
    end

    context "with invalid parameters" do
      it "renders :edit with errors" do
        patch todo_list_path(todo_list), params: { todo_list: { title: "" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Editar lista")
      end
    end
  end

  describe "DELETE /todo_lists/:id" do
    it "removes the list and redirects" do
      expect {
        delete todo_list_path(todo_list)
      }.to change(TodoList, :count).by(-1)
      expect(response).to redirect_to(todo_lists_path)
      follow_redirect!
      expect(response.body).to include("Minhas listas")
    end

    it "redirects if destroy fails" do
      # Simulates destroy failure using allow_any_instance_of
      allow_any_instance_of(TodoList).to receive(:destroy).and_return(false)

      delete todo_list_path(todo_list)
      expect(response).to redirect_to(todo_list)
      follow_redirect!
      expect(response.body).to include("Tarefas")
    end
  end
end
